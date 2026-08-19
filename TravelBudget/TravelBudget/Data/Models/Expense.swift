//
//  Expense.swift
//  TravelBudget
//

import Foundation

struct Expense: Identifiable, Codable, Equatable, Hashable {
    // MARK: - Payment Method
    enum PaymentMethod: String, Codable, CaseIterable {
        case cash
        case card
    }

    // MARK: - Properties
    let id: UUID
    var tripId: UUID
    /// Amount in the currency it was paid in.
    var amount: Double
    /// ISO 4217 code the expense was paid in.
    var currency: String
    /// Amount converted to the trip's home currency, using `rateUsed`.
    var amountHome: Double
    /// Units of `currency` per 1 unit of home currency at `rateDate` (locked, user-editable).
    var rateUsed: Double
    var rateDate: Date
    var category: ExpenseCategory
    var note: String
    var date: Date
    var paymentMethod: PaymentMethod

    // MARK: - Init
    init(
        id: UUID = UUID(),
        tripId: UUID,
        amount: Double,
        currency: String,
        amountHome: Double,
        rateUsed: Double,
        rateDate: Date = Date(),
        category: ExpenseCategory,
        note: String = "",
        date: Date = Date(),
        paymentMethod: PaymentMethod = .card
    ) {
        self.id = id
        self.tripId = tripId
        self.amount = amount
        self.currency = currency
        self.amountHome = amountHome
        self.rateUsed = rateUsed
        self.rateDate = rateDate
        self.category = category
        self.note = note
        self.date = date
        self.paymentMethod = paymentMethod
    }
}
