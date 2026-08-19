//
//  TravelBudgetWidget.swift
//  TravelBudgetWidget
//

import WidgetKit
import SwiftUI

// MARK: - Timeline
struct SnapshotEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetSnapshot?
}

struct SnapshotProvider: TimelineProvider {
    func placeholder(in context: Context) -> SnapshotEntry {
        SnapshotEntry(date: Date(), snapshot: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (SnapshotEntry) -> Void) {
        completion(SnapshotEntry(date: Date(), snapshot: WidgetSnapshot.load() ?? .placeholder))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SnapshotEntry>) -> Void) {
        let entry = SnapshotEntry(date: Date(), snapshot: WidgetSnapshot.load())
        let midnight = Calendar.current.startOfDay(
            for: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        )
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }
}

// MARK: - Widget
struct TravelBudgetWidget: Widget {
    let kind: String = "TravelBudgetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SnapshotProvider()) { entry in
            WidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color(red: 0.97, green: 0.965, blue: 0.95)
                }
        }
        .configurationDisplayName(String(localized: "widget.displayName"))
        .description(String(localized: "widget.description"))
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Views
struct WidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    let entry: SnapshotEntry

    private let teal = Color(red: 0.047, green: 0.455, blue: 0.537)
    private let coral = Color(red: 1.0, green: 0.478, blue: 0.271)

    var body: some View {
        if let snapshot = entry.snapshot {
            switch family {
            case .systemMedium: medium(snapshot)
            default: small(snapshot)
            }
        } else {
            empty
        }
    }

    // MARK: Small
    private func small(_ snapshot: WidgetSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(snapshot.emoji)
                Text(snapshot.tripName)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            Text(String(localized: "widget.today"))
                .font(.caption2)
                .foregroundStyle(.secondary)
            if let safe = snapshot.safeToSpendToday {
                Text(snapshot.format(max(0, safe - snapshot.spentToday)))
                    .font(.title2.weight(.bold))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundStyle(teal)
            } else {
                Text(snapshot.format(snapshot.spentToday))
                    .font(.title2.weight(.bold))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundStyle(teal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }

    // MARK: Medium
    private func medium(_ snapshot: WidgetSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Text(snapshot.emoji)
                Text(snapshot.tripName)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Spacer()
                if let remaining = snapshot.remaining {
                    Text(snapshot.format(remaining))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(teal)
                }
            }
            if let budget = snapshot.budgetTotal, budget > 0, let remaining = snapshot.remaining {
                ProgressView(value: min(1, max(0, (budget - remaining) / budget)))
                    .tint(coral)
            }
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(String(localized: "widget.today"))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    if let safe = snapshot.safeToSpendToday {
                        Text(snapshot.format(max(0, safe - snapshot.spentToday)))
                            .font(.headline.weight(.bold))
                            .foregroundStyle(teal)
                    } else {
                        Text(snapshot.format(snapshot.spentToday))
                            .font(.headline.weight(.bold))
                            .foregroundStyle(teal)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(localized: "widget.spentToday"))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(snapshot.format(snapshot.spentToday))
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }

    // MARK: Empty
    private var empty: some View {
        VStack(spacing: 6) {
            Image(systemName: "airplane.departure")
                .font(.title2)
                .foregroundStyle(teal)
            Text(String(localized: "widget.empty"))
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
    }
}
