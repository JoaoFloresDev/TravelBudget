import SwiftUI
import GambitScreenshotKit

// MARK: - Slot 1 — Trips Home (mirror of TripsHomeView.swift)
//
// Large "Trips" title + plus, TripHeroCard for the current trip (safe to
// spend today) and the Upcoming / Past sections with one TripRowView each.

struct TripsHomeScreen: View {
    let locale: String

    var body: some View {
        ZStack(alignment: .top) {
            MockTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                iOSStatusBar()

                MockLargeTitleHeader(title: L.t("trips.title", locale))

                VStack(alignment: .leading, spacing: 0) {
                    MockTripHeroCard(locale: locale)
                        .padding(.vertical, MockSpacing.sm)

                    sectionHeader(L.t("trips.section.active", locale))
                    MockTripRow(
                        emoji: MockTripData.emoji,
                        name: MockTripData.name(locale),
                        dates: MockTripData.dateRange(locale),
                        spent: MockMoney.s("spent", locale),
                        budget: MockMoney.s("budgetCompact", locale)
                    )
                    .padding(.vertical, MockSpacing.xs + 2)

                    sectionHeader(L.t("trips.section.upcoming", locale))
                    MockTripRow(
                        emoji: MockTripData.romeEmoji,
                        name: MockTripData.romeName(locale),
                        dates: MockTripData.romeDateRange(locale),
                        spent: MockMoney.s("romeSpent", locale),
                        budget: MockMoney.s("romeBudget", locale)
                    )
                    .padding(.vertical, MockSpacing.xs + 2)

                    sectionHeader(L.t("trips.section.past", locale))
                    MockTripRow(
                        emoji: MockTripData.parisEmoji,
                        name: MockTripData.parisName(locale),
                        dates: MockTripData.parisDateRange(locale),
                        spent: MockMoney.s("parisSpent", locale),
                        budget: MockMoney.s("parisBudget", locale),
                        isDimmed: true
                    )
                    .padding(.vertical, MockSpacing.xs + 2)
                }
                .padding(.horizontal, MockSpacing.screenPadding)

                Spacer(minLength: 0)

                MockTabBar(locale: locale, selected: .trips)
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(MockFonts.footnote)
            .fontWeight(.semibold)
            .foregroundStyle(MockTheme.textSecondary)
            .padding(.leading, MockSpacing.xs)
            .padding(.top, MockSpacing.md)
            .padding(.bottom, MockSpacing.xs)
    }
}
