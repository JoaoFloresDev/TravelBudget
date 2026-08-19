//
//  BudgetEngine.swift
//  TravelBudget
//

import Foundation

/// Pure budget math for a trip. All amounts in the trip's home currency.
enum BudgetEngine {
    struct Summary {
        let spentTotal: Double
        let spentToday: Double
        let remaining: Double?
        /// Amount available today keeping the remaining budget spread over the remaining days.
        let safeToSpendToday: Double?
        let daysLeft: Int?
    }

    // MARK: - Summary
    static func summary(trip: Trip, expenses: [Expense], today: Date = Date()) -> Summary {
        let tripExpenses = expenses.filter { $0.tripId == trip.id }
        let spentTotal = tripExpenses.reduce(0) { $0 + $1.amountHome }
        let todayStart = today.dayStart
        let spentToday = tripExpenses
            .filter { Calendar.current.isDate($0.date, inSameDayAs: todayStart) }
            .reduce(0) { $0 + $1.amountHome }

        guard let budget = trip.budgetTotal else {
            return Summary(
                spentTotal: spentTotal,
                spentToday: spentToday,
                remaining: nil,
                safeToSpendToday: nil,
                daysLeft: nil
            )
        }

        let remaining = budget - spentTotal

        // Safe-to-spend only makes sense while the trip is running (or upcoming: full daily).
        guard todayStart <= trip.endDate.dayStart else {
            return Summary(
                spentTotal: spentTotal,
                spentToday: spentToday,
                remaining: remaining,
                safeToSpendToday: nil,
                daysLeft: 0
            )
        }

        let effectiveStart = max(todayStart, trip.startDate.dayStart)
        let daysLeft = effectiveStart.inclusiveDays(until: trip.endDate)
        let spentBeforeToday = spentTotal - spentToday
        let safeToday = (budget - spentBeforeToday) / Double(daysLeft)

        return Summary(
            spentTotal: spentTotal,
            spentToday: spentToday,
            remaining: remaining,
            safeToSpendToday: safeToday,
            daysLeft: daysLeft
        )
    }

    // MARK: - Category Breakdown
    static func byCategory(trip: Trip, expenses: [Expense]) -> [(category: ExpenseCategory, total: Double)] {
        let tripExpenses = expenses.filter { $0.tripId == trip.id }
        let grouped = Dictionary(grouping: tripExpenses, by: { $0.category })
        return grouped
            .map { (category: $0.key, total: $0.value.reduce(0) { $0 + $1.amountHome }) }
            .sorted { $0.total > $1.total }
    }

    // MARK: - Daily Series
    static func dailyTotals(trip: Trip, expenses: [Expense]) -> [(day: Date, total: Double)] {
        let tripExpenses = expenses.filter { $0.tripId == trip.id }
        let grouped = Dictionary(grouping: tripExpenses, by: { $0.date.dayStart })
        return grouped
            .map { (day: $0.key, total: $0.value.reduce(0) { $0 + $1.amountHome }) }
            .sorted { $0.day < $1.day }
    }
}
