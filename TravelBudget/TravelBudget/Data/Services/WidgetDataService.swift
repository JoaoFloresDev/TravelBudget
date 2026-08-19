//
//  WidgetDataService.swift
//  TravelBudget
//

import Foundation
import WidgetKit

/// Publishes the current-trip snapshot the widget renders.
/// Keep field names in sync with `WidgetSnapshot` in the widget target.
@MainActor
final class WidgetDataService {
    // MARK: - Snapshot
    struct Snapshot: Codable {
        let tripName: String
        let emoji: String
        let currencyCode: String
        let spentToday: Double
        let safeToSpendToday: Double?
        let remaining: Double?
        let budgetTotal: Double?
        let updatedAt: Date
    }

    // MARK: - Singleton
    static let shared = WidgetDataService()
    private init() {}

    private let snapshotFile = "widget.json"

    // MARK: - Publish
    func publishSnapshot(store: TripStore) {
        guard let trip = store.currentTrip else {
            StorageService.shared.save(Snapshot?.none, to: snapshotFile)
            WidgetCenter.shared.reloadAllTimelines()
            return
        }
        let summary = BudgetEngine.summary(trip: trip, expenses: store.expenses)
        let snapshot = Snapshot(
            tripName: trip.name,
            emoji: trip.emoji,
            currencyCode: trip.homeCurrency,
            spentToday: summary.spentToday,
            safeToSpendToday: summary.safeToSpendToday,
            remaining: summary.remaining,
            budgetTotal: trip.budgetTotal,
            updatedAt: Date()
        )
        StorageService.shared.save(snapshot, to: snapshotFile)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
