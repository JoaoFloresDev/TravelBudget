import Foundation

/// ViewModel for TripDetailView — one-shot rate refresh plus pure derivations
/// over the live store data (day grouping, trip day math, rate footer).
@MainActor
final class TripDetailViewModel: ObservableObject {

    // MARK: - Types
    /// Expenses of one calendar day with the day total in home currency.
    struct DaySection: Identifiable {
        let id: Date
        let date: Date
        let total: Double
        let expenses: [Expense]
    }

    // MARK: - Published Properties
    @Published private(set) var hasRefreshedRates = false

    // MARK: - Public Methods
    /// Refreshes the cached rate table once per screen lifetime.
    func refreshRatesIfNeeded(base: String) async {
        guard !hasRefreshedRates else { return }
        hasRefreshedRates = true
        await CurrencyService.shared.refreshIfNeeded(base: base)
    }

    // MARK: - Derivations
    /// Groups expenses by calendar day, newest day first, newest expense first inside a day.
    static func daySections(from expenses: [Expense]) -> [DaySection] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: expenses) { calendar.startOfDay(for: $0.date) }
        return grouped
            .map { day, items in
                DaySection(
                    id: day,
                    date: day,
                    total: items.reduce(0) { $0 + $1.amountHome },
                    expenses: items.sorted { $0.date > $1.date }
                )
            }
            .sorted { $0.date > $1.date }
    }

    /// 1-based day index of the trip for today, clamped to the trip length.
    static func dayIndex(for trip: Trip, today: Date = Date()) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: trip.startDate)
        let elapsed = calendar.dateComponents(
            [.day],
            from: start,
            to: calendar.startOfDay(for: today)
        ).day ?? 0
        return min(max(elapsed + 1, 1), max(trip.totalDays, 1))
    }

    /// "1 HOME = X CUR · date" footer for the most used foreign currency, if any.
    static func rateInfoText(trip: Trip, expenses: [Expense]) -> String? {
        let foreignCodes = expenses.map(\.currency).filter { $0 != trip.homeCurrency }
        guard let code = mostFrequent(in: foreignCodes) else { return nil }
        guard let table = CurrencyService.shared.cachedTable(base: trip.homeCurrency),
              let rate = CurrencyService.shared.rate(base: trip.homeCurrency, currency: code) else {
            return nil
        }
        let rateText = String(format: "%.2f", rate)
        let dateText = table.fetchedAt.formatted(date: .abbreviated, time: .omitted)
        return String(localized: "trip.detail.rateInfo \(trip.homeCurrency) \(rateText) \(code) \(dateText)")
    }

    // MARK: - Private Methods
    private static func mostFrequent(in codes: [String]) -> String? {
        let counts = Dictionary(grouping: codes) { $0 }.mapValues(\.count)
        return counts.max { lhs, rhs in
            lhs.value == rhs.value ? lhs.key > rhs.key : lhs.value < rhs.value
        }?.key
    }
}
