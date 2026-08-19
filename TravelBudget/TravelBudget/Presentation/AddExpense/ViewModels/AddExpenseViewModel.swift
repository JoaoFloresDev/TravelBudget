import Foundation
import SwiftUI
import GambitCoreKit

/// ViewModel for AddExpenseSheet — form state, live currency conversion and persistence.
@MainActor
final class AddExpenseViewModel: ObservableObject {

    // MARK: - Properties

    let trip: Trip
    let editingExpense: Expense?
    private let store: TripStore = .shared
    private let currencyService: CurrencyService = .shared

    // MARK: - Published Properties

    @Published var amountText: String = ""
    @Published var currencyCode: String
    @Published var category: ExpenseCategory = .food
    @Published var note: String = ""
    @Published var date: Date = Date()
    @Published var paymentMethod: Expense.PaymentMethod = .card
    @Published var manualRateText: String = ""
    @Published private(set) var lockedRate: Double?
    @Published private(set) var lockedRateDate: Date?
    @Published private(set) var didRefreshRates = false

    // MARK: - Computed Properties

    var isEditing: Bool { editingExpense != nil }
    var homeCurrency: String { trip.homeCurrency }
    var isSameCurrency: Bool { currencyCode == homeCurrency }

    var amountValue: Double {
        Self.parseDecimal(amountText) ?? 0
    }

    /// Units of the paid currency per 1 home unit. Locked (edit/original or
    /// manual override) wins over the live cached rate.
    var effectiveRate: Double? {
        if isSameCurrency { return 1 }
        if let lockedRate { return lockedRate }
        return currencyService.rate(base: homeCurrency, currency: currencyCode)
    }

    var effectiveRateDate: Date {
        if isSameCurrency { return Date() }
        if lockedRate != nil, let lockedRateDate { return lockedRateDate }
        return currencyService.cachedTable(base: homeCurrency)?.fetchedAt ?? Date()
    }

    var isRateUnavailable: Bool { !isSameCurrency && effectiveRate == nil }

    var showsManualRateEntry: Bool { isRateUnavailable || !manualRateText.isEmpty }

    var convertedAmountHome: Double? {
        guard !isSameCurrency, let rate = effectiveRate, rate > 0 else { return nil }
        return amountValue / rate
    }

    var canSave: Bool { amountValue > 0 && effectiveRate != nil }

    var conversionLineText: String? {
        guard let converted = convertedAmountHome, let rate = effectiveRate else { return nil }
        return String(
            format: String(localized: "expense.form.conversion.line"),
            CurrencyCatalog.format(converted, code: homeCurrency),
            homeCurrency,
            Self.rateFormatter.string(from: NSNumber(value: rate)) ?? "\(rate)",
            currencyCode,
            Self.rateDateFormatter.string(from: effectiveRateDate)
        )
    }

    var editableRateText: String {
        guard !isSameCurrency, let rate = effectiveRate else { return "" }
        return Self.rateFormatter.string(from: NSNumber(value: rate)) ?? ""
    }

    var frequentCurrencyCodes: [String] {
        var codes = [homeCurrency]
        if let last = UserDefaults.standard.string(forKey: StorageKeys.lastUsedCurrency),
           !codes.contains(last) {
            codes.append(last)
        }
        if !codes.contains(currencyCode) {
            codes.append(currencyCode)
        }
        return codes
    }

    var otherCurrencyEntries: [CurrencyCatalog.Entry] {
        let frequent = Set(frequentCurrencyCodes)
        return CurrencyCatalog.all.filter { !frequent.contains($0.code) }
    }

    // MARK: - Formatters

    private static let rateFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        return formatter
    }()

    private static let rateDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    // MARK: - Init

    init(trip: Trip, expense: Expense? = nil) {
        self.trip = trip
        self.editingExpense = expense
        if let expense {
            self.currencyCode = expense.currency
            self.amountText = Self.editableAmountText(expense.amount)
            self.category = expense.category
            self.note = expense.note
            self.date = expense.date
            self.paymentMethod = expense.paymentMethod
            if expense.currency != trip.homeCurrency {
                self.lockedRate = expense.rateUsed
                self.lockedRateDate = expense.rateDate
            }
        } else {
            let lastUsed = UserDefaults.standard.string(forKey: StorageKeys.lastUsedCurrency)
            self.currencyCode = lastUsed ?? trip.homeCurrency
        }
    }

    // MARK: - Public Methods

    func refreshRatesIfNeeded() async {
        await currencyService.refreshIfNeeded(base: homeCurrency)
        didRefreshRates = true
    }

    func selectCurrency(_ code: String) {
        if code == currencyCode { return }
        currencyCode = code
        lockedRate = nil
        lockedRateDate = nil
        manualRateText = ""
        HapticManager.selection()
    }

    func selectCategory(_ newCategory: ExpenseCategory) {
        category = newCategory
        HapticManager.selection()
    }

    func selectPaymentMethod(_ method: Expense.PaymentMethod) {
        paymentMethod = method
        HapticManager.selection()
    }

    func overrideRate(text: String) {
        guard let value = Self.parseDecimal(text), value > 0 else { return }
        lockedRate = value
        lockedRateDate = Date()
        HapticManager.selection()
    }

    func applyManualRate() {
        guard let value = Self.parseDecimal(manualRateText), value > 0 else {
            lockedRate = nil
            lockedRateDate = nil
            return
        }
        lockedRate = value
        lockedRateDate = Date()
    }

    func save() -> Bool {
        guard canSave, let rate = effectiveRate, rate > 0 else { return false }
        let amountHome = isSameCurrency ? amountValue : amountValue / rate
        if var expense = editingExpense {
            expense.amount = amountValue
            expense.currency = currencyCode
            expense.amountHome = amountHome
            expense.rateUsed = rate
            expense.rateDate = effectiveRateDate
            expense.category = category
            expense.note = note
            expense.date = date
            expense.paymentMethod = paymentMethod
            store.update(expense)
        } else {
            let expense = Expense(
                id: UUID(),
                tripId: trip.id,
                amount: amountValue,
                currency: currencyCode,
                amountHome: amountHome,
                rateUsed: rate,
                rateDate: effectiveRateDate,
                category: category,
                note: note,
                date: date,
                paymentMethod: paymentMethod
            )
            store.add(expense)
        }
        UserDefaults.standard.set(currencyCode, forKey: StorageKeys.lastUsedCurrency)
        HapticManager.success()
        ReviewService.shared.recordPositiveEvent()
        return true
    }

    func deleteExpense() {
        guard let expense = editingExpense else { return }
        store.deleteExpense(expense.id)
        HapticManager.warning()
    }

    // MARK: - Private Methods

    private static func parseDecimal(_ text: String) -> Double? {
        let normalized = text
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)
        return Double(normalized)
    }

    private static func editableAmountText(_ value: Double) -> String {
        if value == value.rounded() {
            return String(format: "%.0f", value)
        }
        return String(format: "%.2f", value)
    }
}
