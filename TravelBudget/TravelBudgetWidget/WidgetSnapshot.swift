//
//  WidgetSnapshot.swift
//  TravelBudgetWidget
//

import Foundation

/// Mirror of the app's `WidgetDataService.Snapshot` — keep field names in sync.
struct WidgetSnapshot: Codable {
    let tripName: String
    let emoji: String
    let currencyCode: String
    let spentToday: Double
    let safeToSpendToday: Double?
    let remaining: Double?
    let budgetTotal: Double?
    let updatedAt: Date

    // MARK: - Loading
    static func load() -> WidgetSnapshot? {
        guard let container = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.gambitstudio.travelbudget"
        ) else { return nil }
        let url = container.appendingPathComponent("widget.json")
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(WidgetSnapshot.self, from: data)
    }

    // MARK: - Formatting
    func format(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.maximumFractionDigits = abs(value) >= 1000 ? 0 : 2
        return formatter.string(from: NSNumber(value: value)) ?? "\(currencyCode) \(value)"
    }

    // MARK: - Placeholder
    static let placeholder = WidgetSnapshot(
        tripName: "Lisbon",
        emoji: "🇵🇹",
        currencyCode: "USD",
        spentToday: 46,
        safeToSpendToday: 128,
        remaining: 1240,
        budgetTotal: 1800,
        updatedAt: Date()
    )
}
