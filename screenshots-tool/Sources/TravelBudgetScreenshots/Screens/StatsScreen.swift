import SwiftUI
import GambitScreenshotKit

// MARK: - Slot 5 — Stats (mirror of StatsView.swift)
//
// Trip picker chips, three summary tiles, "Spending by day" bar chart with
// the dashed daily-target rule, and the category breakdown card.

struct StatsScreen: View {
    let locale: String

    var body: some View {
        ZStack(alignment: .top) {
            MockTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                iOSStatusBar()

                MockLargeTitleHeader(
                    title: L.t("stats.title", locale),
                    trailingSymbol: nil
                )

                VStack(alignment: .leading, spacing: MockSpacing.md) {
                    tripPicker

                    MockStatsTiles(locale: locale)

                    sectionHeader(L.t("stats.section.daily", locale))
                    MockDailyChartCard(locale: locale)

                    sectionHeader(L.t("stats.section.categories", locale))
                    MockCategoryBreakdownCard(locale: locale)
                }
                .padding(.horizontal, MockSpacing.screenPadding)

                Spacer(minLength: 0)
            }
        }
    }

    // MARK: - Trip Picker (mirror of StatsTripPicker.swift)

    private var tripPicker: some View {
        HStack(spacing: MockSpacing.sm) {
            chip(emoji: MockTripData.emoji, name: MockTripData.name(locale), isSelected: true)
            chip(emoji: MockTripData.romeEmoji, name: MockTripData.romeName(locale), isSelected: false)
            chip(emoji: MockTripData.parisEmoji, name: MockTripData.parisName(locale), isSelected: false)
            Spacer(minLength: 0)
        }
        .padding(.vertical, MockSpacing.xs)
    }

    private func chip(emoji: String, name: String, isSelected: Bool) -> some View {
        HStack(spacing: MockSpacing.xs + 2) {
            Text(emoji)
                .font(MockFonts.subheadline)
            Text(name)
                .font(MockFonts.bodyMedium)
                .lineLimit(1)
                .foregroundStyle(isSelected ? Color.white : MockTheme.textPrimary)
        }
        .padding(.horizontal, MockSpacing.md)
        .frame(minHeight: 44)
        .background(
            Capsule()
                .fill(isSelected ? MockTheme.primary : MockTheme.surface)
        )
        .overlay(
            Capsule()
                .strokeBorder(
                    isSelected ? Color.clear : MockTheme.textTertiary.opacity(0.25),
                    lineWidth: 1
                )
        )
        .mockSoftShadow()
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(MockFonts.headline)
            .foregroundStyle(MockTheme.textPrimary)
            .padding(.top, MockSpacing.xs)
    }
}
