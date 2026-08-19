import SwiftUI

// MARK: - Widget Recreations (mirror of TravelBudgetWidget.swift, light mode)
//
// Faithful to the WidgetKit views: small = trip header, "Today you can
// spend" caption + big teal amount; medium = header + remaining, coral
// progress bar, safe-today (teal) and spent-today columns.

struct MockWidgetSmall: View {
    let locale: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(MockTripData.emoji)
                    .font(.system(size: 13))
                Text(MockTripData.name(locale))
                    .font(.system(size: 12, weight: .semibold))
                    .lineLimit(1)
                    .foregroundStyle(MockTheme.textSecondary)
            }
            Spacer(minLength: 0)
            Text(L.t("widget.today", locale))
                .font(.system(size: 11))
                .foregroundStyle(MockTheme.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(MockMoney.s("safeToday", locale))
                .font(.system(size: 22, weight: .bold))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .foregroundStyle(MockTheme.widgetTeal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(MockTheme.widgetBackground)
        )
        .mockElevatedShadow()
    }
}

struct MockWidgetMedium: View {
    let locale: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 4) {
                Text(MockTripData.emoji)
                    .font(.system(size: 15))
                Text(MockTripData.name(locale))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(MockTheme.textPrimary)
                    .lineLimit(1)
                Spacer()
                Text(MockMoney.s("remaining", locale))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(MockTheme.widgetTeal)
            }

            progressBar

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(L.t("widget.today", locale))
                        .font(.system(size: 11))
                        .foregroundStyle(MockTheme.textSecondary)
                    Text(MockMoney.s("safeToday", locale))
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(MockTheme.widgetTeal)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(L.t("widget.spentToday", locale))
                        .font(.system(size: 11))
                        .foregroundStyle(MockTheme.textSecondary)
                    Text(MockMoney.s("spentToday", locale))
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(MockTheme.textPrimary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity, alignment: .center)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(MockTheme.widgetBackground)
        )
        .mockElevatedShadow()
    }

    private var progressBar: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(MockTheme.widgetCoral.opacity(0.25))
            GeometryReader { geo in
                Capsule()
                    .fill(MockTheme.widgetCoral)
                    .frame(width: geo.size.width * MockTripData.budgetProgress)
            }
        }
        .frame(height: 4)
    }
}

// MARK: - Home-Screen App Icon (generic SF Symbol icons for the widget print)

struct MockHomeIcon: View {
    let symbol: String
    let label: String
    let colors: [Color]
    var glyph: Color = .white

    var body: some View {
        VStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: symbol)
                        .font(.system(size: 27, weight: .medium))
                        .foregroundStyle(glyph)
                )
                .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 2)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.35), radius: 2, x: 0, y: 1)
                .lineLimit(1)
        }
        .frame(width: 76)
    }
}

enum MockHomeIconSet {
    /// (symbol, gradient, glyph color) per icon slot — muted, realistic system-app tones.
    static let styles: [(String, [Color], Color)] = [
        ("photo.on.rectangle", [Color(red: 0.98, green: 0.98, blue: 0.99), Color(red: 0.85, green: 0.87, blue: 0.90)],
         Color(red: 0.35, green: 0.55, blue: 0.90)),
        ("camera.fill",        [Color(red: 0.45, green: 0.47, blue: 0.52), Color(red: 0.24, green: 0.26, blue: 0.30)], .white),
        ("map.fill",           [Color(red: 0.36, green: 0.78, blue: 0.47), Color(red: 0.16, green: 0.58, blue: 0.34)], .white),
        ("music.note",         [Color(red: 0.99, green: 0.42, blue: 0.52), Color(red: 0.91, green: 0.19, blue: 0.35)], .white),
        ("envelope.fill",      [Color(red: 0.42, green: 0.71, blue: 0.99), Color(red: 0.13, green: 0.44, blue: 0.92)], .white),
        ("sun.max.fill",       [Color(red: 0.38, green: 0.66, blue: 0.94), Color(red: 0.17, green: 0.39, blue: 0.75)],
         Color(red: 1.00, green: 0.85, blue: 0.30)),
        ("clock.fill",         [Color(red: 0.22, green: 0.23, blue: 0.26), Color(red: 0.09, green: 0.10, blue: 0.12)], .white),
        ("note.text",          [Color(red: 0.99, green: 0.85, blue: 0.35), Color(red: 0.95, green: 0.68, blue: 0.15)], .white),
        ("calendar",           [Color(red: 0.98, green: 0.98, blue: 0.99), Color(red: 0.88, green: 0.89, blue: 0.92)],
         Color(red: 0.90, green: 0.25, blue: 0.25)),
        ("creditcard.fill",    [Color(red: 0.28, green: 0.30, blue: 0.35), Color(red: 0.13, green: 0.14, blue: 0.17)], .white),
        ("video.fill",         [Color(red: 0.55, green: 0.62, blue: 0.99), Color(red: 0.30, green: 0.36, blue: 0.92)], .white),
        ("heart.fill",         [Color(red: 0.99, green: 0.98, blue: 0.99), Color(red: 0.92, green: 0.90, blue: 0.92)],
         Color(red: 0.95, green: 0.30, blue: 0.45))
    ]

    static let dock: [(String, [Color])] = [
        ("phone.fill",   [Color(red: 0.42, green: 0.86, blue: 0.47), Color(red: 0.15, green: 0.66, blue: 0.28)]),
        ("safari.fill",  [Color(red: 0.44, green: 0.72, blue: 0.99), Color(red: 0.12, green: 0.41, blue: 0.90)]),
        ("message.fill", [Color(red: 0.42, green: 0.87, blue: 0.45), Color(red: 0.14, green: 0.68, blue: 0.26)]),
        ("gearshape.fill", [Color(red: 0.62, green: 0.64, blue: 0.68), Color(red: 0.36, green: 0.38, blue: 0.42)])
    ]
}
