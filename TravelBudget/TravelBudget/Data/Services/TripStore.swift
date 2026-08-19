//
//  TripStore.swift
//  TravelBudget
//

import Foundation
import Combine

/// Source of truth for trips + expenses. ViewModels observe this store.
@MainActor
final class TripStore: ObservableObject {
    // MARK: - Singleton
    static let shared = TripStore()

    // MARK: - Published State
    @Published private(set) var trips: [Trip] = []
    @Published private(set) var expenses: [Expense] = []

    // MARK: - Files
    private let tripsFile = "trips.json"
    private let expensesFile = "expenses.json"

    // MARK: - Init
    private init() {
        if FeatureFlags.isMockedData {
            let mock = MockDataProvider.sampleData()
            trips = mock.trips
            expenses = mock.expenses
        } else {
            trips = StorageService.shared.load([Trip].self, from: tripsFile) ?? []
            expenses = StorageService.shared.load([Expense].self, from: expensesFile) ?? []
        }
    }

    // MARK: - Trip CRUD
    func add(_ trip: Trip) {
        trips.append(trip)
        persistTrips()
    }

    func update(_ trip: Trip) {
        guard let index = trips.firstIndex(where: { $0.id == trip.id }) else { return }
        trips[index] = trip
        persistTrips()
    }

    func deleteTrip(_ id: UUID) {
        trips.removeAll { $0.id == id }
        expenses.removeAll { $0.tripId == id }
        persistTrips()
        persistExpenses()
    }

    // MARK: - Expense CRUD
    func add(_ expense: Expense) {
        expenses.append(expense)
        persistExpenses()
    }

    func update(_ expense: Expense) {
        guard let index = expenses.firstIndex(where: { $0.id == expense.id }) else { return }
        expenses[index] = expense
        persistExpenses()
    }

    func deleteExpense(_ id: UUID) {
        expenses.removeAll { $0.id == id }
        persistExpenses()
    }

    // MARK: - Queries
    func expenses(for tripId: UUID) -> [Expense] {
        expenses
            .filter { $0.tripId == tripId }
            .sorted { $0.date > $1.date }
    }

    /// Active trip preference: pinned > date-active > most recently started.
    var currentTrip: Trip? {
        if let pinnedString = UserDefaults.standard.string(forKey: StorageKeys.pinnedTripId),
           let pinnedId = UUID(uuidString: pinnedString),
           let pinned = trips.first(where: { $0.id == pinnedId }) {
            return pinned
        }
        if let active = trips.filter({ $0.isActive }).min(by: { $0.startDate < $1.startDate }) {
            return active
        }
        return trips.sorted { $0.startDate > $1.startDate }.first
    }

    // MARK: - Persistence
    private func persistTrips() {
        StorageService.shared.save(trips, to: tripsFile)
        refreshWidget()
    }

    private func persistExpenses() {
        StorageService.shared.save(expenses, to: expensesFile)
        refreshWidget()
    }

    private func refreshWidget() {
        WidgetDataService.shared.publishSnapshot(store: self)
    }
}
