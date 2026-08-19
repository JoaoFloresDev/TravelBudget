//
//  TravelBudgetWidget.swift
//  TravelBudgetWidget
//

import WidgetKit
import SwiftUI
import UIKit

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
                    WidgetPalette.background
                }
        }
        .configurationDisplayName(String(localized: "widget.displayName"))
        .description(String(localized: "widget.description"))
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Palette
/// App palette mirrored for the widget target (light + dark variants, same as AppTheme).
enum WidgetPalette {
    static let background = dynamic(
        light: (0xF7, 0xF6, 0xF2), dark: (0x10, 0x12, 0x14)
    )
    static let teal = dynamic(
        light: (0x0C, 0x74, 0x89), dark: (0x2D, 0xA4, 0xBB)
    )
    static let coral = dynamic(
        light: (0xFF, 0x7A, 0x45), dark: (0xFF, 0x8F, 0x63)
    )

    private static func dynamic(
        light: (Int, Int, Int), dark: (Int, Int, Int)
    ) -> Color {
        Color(uiColor: UIColor { trait in
            let rgb = trait.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat(rgb.0) / 255,
                green: CGFloat(rgb.1) / 255,
                blue: CGFloat(rgb.2) / 255,
                alpha: 1
            )
        })
    }
}

// MARK: - Views
struct WidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    let entry: SnapshotEntry

    private let teal = WidgetPalette.teal
    private let coral = WidgetPalette.coral

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
