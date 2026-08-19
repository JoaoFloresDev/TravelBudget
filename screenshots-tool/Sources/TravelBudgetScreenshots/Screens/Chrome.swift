import SwiftUI
import GambitScreenshotKit

// MARK: - Shared Screen Chrome (tab bar, nav bars, home indicator)

// MARK: - Tab Bar (mirror of MainTabView tabs: Trips / Stats / Settings)

struct MockTabBar: View {
    enum Tab { case trips, stats, settings }

    let locale: String
    let selected: Tab

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(MockTheme.textTertiary.opacity(0.25))
                .frame(height: 0.7)

            HStack {
                item(.trips, symbol: "airplane", label: tabLabel("trips"))
                item(.stats, symbol: "chart.bar.fill", label: tabLabel("stats"))
                item(.settings, symbol: "gearshape.fill", label: tabLabel("settings"))
            }
            .padding(.top, 8)

            Spacer(minLength: 0)

            MockHomeIndicator(color: .black)
                .padding(.bottom, 8)
        }
        .frame(height: 84)
        .background(MockTheme.background.opacity(0.98))
    }

    private func item(_ tab: Tab, symbol: String, label: String) -> some View {
        let isSelected = tab == selected
        return VStack(spacing: 3) {
            Image(systemName: symbol)
                .font(.system(size: 21, weight: .medium))
            Text(label)
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundStyle(isSelected ? MockTheme.primary : MockTheme.textTertiary)
        .frame(maxWidth: .infinity)
    }

    private func tabLabel(_ key: String) -> String {
        switch key {
        case "trips":
            return ["en-US": "Trips", "pt-BR": "Viagens", "es-ES": "Viajes"][locale] ?? "Trips"
        case "stats":
            return ["en-US": "Stats", "pt-BR": "Resumo", "es-ES": "Resumen"][locale] ?? "Stats"
        default:
            return ["en-US": "Settings", "pt-BR": "Ajustes", "es-ES": "Ajustes"][locale] ?? "Settings"
        }
    }
}

// MARK: - Home Indicator

struct MockHomeIndicator: View {
    var color: Color = .black

    var body: some View {
        Capsule()
            .fill(color.opacity(0.85))
            .frame(width: 140, height: 5)
    }
}

// MARK: - Large Title Header (nav large title + trailing button)

struct MockLargeTitleHeader: View {
    let title: String
    var trailingSymbol: String? = "plus"

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(MockFonts.largeTitle)
                .foregroundStyle(MockTheme.textPrimary)
            Spacer()
            if let trailingSymbol {
                Image(systemName: trailingSymbol)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(MockTheme.primary)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, MockSpacing.screenPadding)
        .padding(.top, 4)
        .padding(.bottom, 6)
    }
}

// MARK: - Inline Nav Bar

struct MockInlineNavBar: View {
    let title: String
    var leading: AnyView? = nil
    var trailing: AnyView? = nil

    var body: some View {
        ZStack {
            Text(title)
                .font(MockFonts.headline)
                .foregroundStyle(MockTheme.textPrimary)
            HStack {
                if let leading { leading }
                Spacer()
                if let trailing { trailing }
            }
            .padding(.horizontal, MockSpacing.md)
        }
        .frame(height: 44)
    }
}
