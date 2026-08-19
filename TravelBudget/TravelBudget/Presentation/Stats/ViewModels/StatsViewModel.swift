//
//  StatsViewModel.swift
//  TravelBudget
//
//  Selection + derived stats for the Stats tab. Pure math delegated to BudgetEngine.
//

import Foundation
import SwiftUI
import GambitCoreKit

// MARK: - Display Models

struct DailySpendPoint: Identifiable {
    let day: Date
    let total: Double
    let isOverTarget: Bool

    var id: Date { day }
}

struct CategoryStat: Identifiable {
    let category: ExpenseCategory
    let total: Double
    let share: Double

    var id: String { category.rawValue }
}

struct TripStatsData {
    let trip: Trip
    let spentTotal: Double
    let averagePerDay: Double
    let dailyTarget: Double?
    let dailyPoints: [DailySpendPoint]
    let categories: [CategoryStat]
    let cashTotal: Double
    let cardTotal: Double

    var hasExpenses: Bool { !categories.isEmpty }
}

// MARK: - ViewModel

@MainActor
final class StatsViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var selectedTripId: UUID?
    @Published private(set) var hasLoadedOnce = false

    // MARK: - Public Methods

    func onAppear(store: TripStore) {
        if selectedTripId == nil {
            selectedTripId = store.currentTrip?.id
        }
        guard !hasLoadedOnce else { return }
        Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 350_000_000)
            withAnimation(.easeOut(duration: 0.25)) {
                self?.hasLoadedOnce = true
            }
        }
    }

    func select(_ trip: Trip) {
        guard trip.id != selectedTripId else { return }
        HapticManager.selection()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            selectedTripId = trip.id
        }
    }

    func selectedTrip(in store: TripStore) -> Trip? {
        if let id = selectedTripId,
           let trip = store.trips.first(where: { $0.id == id }) {
            return trip
        }
        return store.currentTrip ?? store.trips[safe: 0]
    }

    func statsData(for trip: Trip, store: TripStore) -> TripStatsData {
        let expenses = store.expenses(for: trip.id)
        let summary = BudgetEngine.summary(trip: trip, expenses: expenses)
        let elapsed = Self.elapsedDays(trip: trip)
        let target = trip.budgetTotal.map { $0 / Double(max(trip.totalDays, 1)) }

        let points = BudgetEngine.dailyTotals(trip: trip, expenses: expenses).map { entry in
            DailySpendPoint(
                day: entry.day,
                total: entry.total,
                isOverTarget: target.map { entry.total > $0 } ?? false
            )
        }

        let byCategory = BudgetEngine.byCategory(trip: trip, expenses: expenses)
        let categoryTotal = byCategory.reduce(0) { $0 + $1.total }
        let categories = byCategory.map { entry in
            CategoryStat(
                category: entry.category,
                total: entry.total,
                share: categoryTotal > 0 ? entry.total / categoryTotal : 0
            )
        }

        let cashTotal = expenses
            .filter { $0.paymentMethod == .cash }
            .reduce(0) { $0 + $1.amountHome }

        return TripStatsData(
            trip: trip,
            spentTotal: summary.spentTotal,
            averagePerDay: summary.spentTotal / Double(max(elapsed, 1)),
            dailyTarget: target,
            dailyPoints: points,
            categories: categories,
            cashTotal: cashTotal,
            cardTotal: summary.spentTotal - cashTotal
        )
    }

    // MARK: - Private Methods

    /// Trip days already started, clamped to [1, totalDays].
    static func elapsedDays(trip: Trip, today: Date = Date()) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: trip.startDate)
        let end = calendar.startOfDay(for: trip.endDate)
        let capped = min(calendar.startOfDay(for: today), end)
        guard capped >= start else { return 1 }
        let diff = calendar.dateComponents([.day], from: start, to: capped).day ?? 0
        return min(max(diff + 1, 1), max(trip.totalDays, 1))
    }
}
