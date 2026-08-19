//
//  Trip.swift
//  TravelBudget
//

import Foundation

struct Trip: Identifiable, Codable, Equatable, Hashable {
    // MARK: - Properties
    let id: UUID
    var name: String
    var emoji: String
    var startDate: Date
    var endDate: Date
    /// ISO 4217 code the budget and totals are expressed in.
    var homeCurrency: String
    /// Total budget in home currency. nil = track spending without a budget.
    var budgetTotal: Double?

    // MARK: - Init
    init(
        id: UUID = UUID(),
        name: String,
        emoji: String = "✈️",
        startDate: Date,
        endDate: Date,
        homeCurrency: String,
        budgetTotal: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.startDate = startDate
        self.endDate = endDate
        self.homeCurrency = homeCurrency
        self.budgetTotal = budgetTotal
    }

    // MARK: - Derived
    var totalDays: Int {
        startDate.inclusiveDays(until: endDate)
    }

    var isActive: Bool {
        let today = Date().dayStart
        return today >= startDate.dayStart && today <= endDate.dayStart
    }

    var isUpcoming: Bool {
        Date().dayStart < startDate.dayStart
    }

    var isPast: Bool {
        Date().dayStart > endDate.dayStart
    }
}
