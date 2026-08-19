import SwiftUI
import GambitScreenshotKit

// MARK: - Slot 3 — iOS Home with Widgets (faithful to TravelBudgetWidget.swift)
//
// Realistic iOS home screen: teal-family wallpaper with depth, medium +
// small TravelBudget widgets (mirroring the WidgetKit views), generic
// SF Symbol app icons, page dots and dock. No breakout — the widgets ARE
// the focus of this print.

struct WidgetHomeScreen: View {
    let locale: String

    private let contentWidth: CGFloat = 380

    var body: some View {
        ZStack(alignment: .top) {
            wallpaper

            VStack(spacing: 0) {
                iOSStatusBar(foreground: .white)

                VStack(spacing: 22) {
                    MockWidgetMedium(locale: locale)
                        .frame(width: contentWidth, height: 176)

                    widgetAndIconsRow

                    iconsRow

                    secondIconsRow

                    Spacer(minLength: 0)

                    pageDots

                    dock
                }
                .frame(width: contentWidth)
                .padding(.top, 18)
            }
        }
    }

    // MARK: - Wallpaper (teal family, with depth — inside the device only)

    private var wallpaper: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.32, blue: 0.38),
                    Color(red: 0.04, green: 0.22, blue: 0.27),
                    Color(red: 0.02, green: 0.11, blue: 0.15)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [
                    Color(red: 0.18, green: 0.62, blue: 0.68).opacity(0.55),
                    Color.clear
                ],
                center: UnitPoint(x: 0.30, y: 0.18),
                startRadius: 30,
                endRadius: 480
            )

            RadialGradient(
                colors: [
                    Color(red: 1.00, green: 0.48, blue: 0.27).opacity(0.16),
                    Color.clear
                ],
                center: UnitPoint(x: 0.85, y: 0.85),
                startRadius: 40,
                endRadius: 420
            )
        }
        .ignoresSafeArea()
    }

    // MARK: - Widget + Icon Grid Row

    private var widgetAndIconsRow: some View {
        HStack(alignment: .top, spacing: 20) {
            MockWidgetSmall(locale: locale)
                .frame(width: 180, height: 176)

            VStack(spacing: 14) {
                HStack(spacing: 14) {
                    icon(0)
                    icon(1)
                }
                HStack(spacing: 14) {
                    icon(2)
                    icon(3)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var iconsRow: some View {
        HStack(spacing: 20) {
            icon(4)
            icon(5)
            icon(6)
            icon(7)
        }
        .frame(maxWidth: .infinity)
    }

    private var secondIconsRow: some View {
        HStack(spacing: 20) {
            icon(8)
            icon(9)
            icon(10)
            icon(11)
        }
        .frame(maxWidth: .infinity)
    }

    private func icon(_ index: Int) -> some View {
        let style = MockHomeIconSet.styles[index]
        let label = MockHomeIcons.labels(locale)[index]
        return MockHomeIcon(symbol: style.0, label: label, colors: style.1, glyph: style.2)
    }

    // MARK: - Page Dots

    private var pageDots: some View {
        HStack(spacing: 9) {
            Circle().fill(Color.white).frame(width: 7, height: 7)
            Circle().fill(Color.white.opacity(0.4)).frame(width: 7, height: 7)
            Circle().fill(Color.white.opacity(0.4)).frame(width: 7, height: 7)
        }
        .padding(.bottom, 14)
    }

    // MARK: - Dock

    private var dock: some View {
        VStack(spacing: 0) {
            HStack(spacing: 26) {
                ForEach(0..<MockHomeIconSet.dock.count, id: \.self) { index in
                    let style = MockHomeIconSet.dock[index]
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(LinearGradient(colors: style.1, startPoint: .top, endPoint: .bottom))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: style.0)
                                .font(.system(size: 27, weight: .medium))
                                .foregroundStyle(.white)
                        )
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color.white.opacity(0.16))
            )

            MockHomeIndicator(color: .white)
                .padding(.top, 12)
                .padding(.bottom, 8)
        }
    }
}
