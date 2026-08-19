import SwiftUI

// MARK: - Breakout (house LOOK)
//
// One WHOLE app section, enlarged with a uniform scaleEffect so the ratio
// is preserved, ALWAYS wider than the device mockup (overflows both device
// edges), with a coral border + coral glow (the app's accent — same color
// on all 5 prints) and rounded corners. Rendered as MarketingScreen's
// `foreground`, positioned in canvas space (1320×2868).

struct BreakoutCard<Content: View>: View {
    var nativeWidth: CGFloat = 400
    var targetWidth: CGFloat = 1240
    var cornerRadius: CGFloat = MockSpacing.cornerRadiusLarge
    @ViewBuilder let content: () -> Content

    var body: some View {
        let scale = targetWidth / nativeWidth
        content()
            .frame(width: nativeWidth)
            // Glow = SIBLING blur placed BEHIND the card (RENDERING_NOTES #1:
            // .shadow on a parent with opaque internals bleeds halos inside).
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(MockTheme.breakoutGlow.opacity(0.50))
                        .padding(-10)
                        .blur(radius: 30)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(MockTheme.breakoutGlow.opacity(0.85))
                        .padding(-2)
                        .blur(radius: 10)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(MockTheme.breakoutGlow, lineWidth: 2.5)
            )
            .scaleEffect(scale)
    }
}

// MARK: - Per-Slot Breakout Foregrounds

enum Breakouts {
    /// Slot 1 — the whole TripHeroCard ("safe to spend today").
    @MainActor
    static func home(_ locale: String) -> AnyView {
        AnyView(
            BreakoutCard {
                MockTripHeroCard(locale: locale)
            }
            .position(x: 660, y: 1080)
        )
    }

    /// Slot 2 — the amount + conversion section of the add-expense form.
    @MainActor
    static func addExpense(_ locale: String) -> AnyView {
        AnyView(
            BreakoutCard {
                MockAmountCard(locale: locale)
            }
            .position(x: 660, y: 965)
        )
    }

    /// Slot 4 — the whole CategoryDonutCard.
    @MainActor
    static func tripDetail(_ locale: String) -> AnyView {
        AnyView(
            BreakoutCard(targetWidth: 1200) {
                MockDonutCard(locale: locale)
            }
            .position(x: 660, y: 1780)
        )
    }

    /// Slot 5 — the daily bar chart card with the target rule.
    @MainActor
    static func stats(_ locale: String) -> AnyView {
        AnyView(
            BreakoutCard {
                MockDailyChartCard(locale: locale)
            }
            .position(x: 660, y: 1560)
        )
    }
}
