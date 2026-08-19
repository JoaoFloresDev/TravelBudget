//
//  BudgetEngineTests.swift
//  TravelBudgetTests
//

import XCTest
@testable import TravelBudget

final class BudgetEngineTests: XCTestCase {
    // MARK: - Helpers
    private func makeTrip(budget: Double?, daysFromToday: Int = -2, length: Int = 10) -> Trip {
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .day, value: daysFromToday, to: Date())!
        let end = calendar.date(byAdding: .day, value: length - 1, to: start)!
        return Trip(name: "Test", startDate: start, endDate: end, homeCurrency: "USD", budgetTotal: budget)
    }

    // MARK: - Tests
    func testSummaryWithoutBudget() {
        let trip = makeTrip(budget: nil)
        let expense = Expense(tripId: trip.id, amount: 10, currency: "USD", amountHome: 10, rateUsed: 1, category: .food)
        let summary = BudgetEngine.summary(trip: trip, expenses: [expense])
        XCTAssertEqual(summary.spentTotal, 10, accuracy: 0.001)
        XCTAssertNil(summary.remaining)
        XCTAssertNil(summary.safeToSpendToday)
    }

    func testSafeToSpendSpreadsRemainingBudget() {
        let trip = makeTrip(budget: 800, daysFromToday: -2, length: 10)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let expense = Expense(tripId: trip.id, amount: 160, currency: "USD", amountHome: 160, rateUsed: 1, category: .lodging, date: yesterday)
        let summary = BudgetEngine.summary(trip: trip, expenses: [expense])
        // 8 days left (today..day10), (800-160)/8 = 80
        XCTAssertEqual(summary.daysLeft, 8)
        XCTAssertEqual(summary.safeToSpendToday ?? 0, 80, accuracy: 0.001)
        XCTAssertEqual(summary.remaining ?? 0, 640, accuracy: 0.001)
    }

    func testCategoryBreakdownSortsByTotal() {
        let trip = makeTrip(budget: 500)
        let expenses = [
            Expense(tripId: trip.id, amount: 30, currency: "USD", amountHome: 30, rateUsed: 1, category: .food),
            Expense(tripId: trip.id, amount: 100, currency: "USD", amountHome: 100, rateUsed: 1, category: .lodging)
        ]
        let breakdown = BudgetEngine.byCategory(trip: trip, expenses: expenses)
        XCTAssertEqual(breakdown[safe: 0]?.category, .lodging)
        XCTAssertEqual(breakdown[safe: 1]?.category, .food)
    }
}
