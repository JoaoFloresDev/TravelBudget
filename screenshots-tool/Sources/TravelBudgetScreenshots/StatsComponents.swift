import SwiftUI

// MARK: - Stats Summary Tiles (mirror of StatsSummaryRow.swift)

struct MockStatsTiles: View {
    let locale: String

    var body: some View {
        HStack(spacing: MockSpacing.sm) {
            tile(
                title: L.t("stats.summary.spent", locale),
                value: MockMoney.s("spent", locale),
                tint: MockTheme.primary
            )
            tile(
                title: L.t("stats.summary.avgPerDay", locale),
                value: MockMoney.s("avgPerDay", locale),
                tint: MockTheme.secondary
            )
            tile(
                title: L.t("stats.summary.dailyTarget", locale),
                value: MockMoney.s("dailyTarget", locale),
                tint: MockTheme.accent
            )
        }
    }

    private func tile(title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: MockSpacing.xs) {
            Text(title)
                .font(MockFonts.caption)
                .foregroundStyle(MockTheme.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(value)
                .font(MockFonts.headline)
                .foregroundStyle(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        .padding(MockSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: MockSpacing.cornerRadius)
                .fill(MockTheme.surface)
        )
        .mockSoftShadow()
    }
}

// MARK: - Daily Bar Chart Card (mirror of StatsDailyChart.swift)
//
// Swift Charts is recreated with deterministic SwiftUI drawing (grid lines,
// trailing axis labels, rounded bars, dashed coral target rule) so the
// macOS ImageRenderer output is stable and faithful to the on-device look.

struct MockDailyChartCard: View {
    let locale: String

    private let chartHeight: CGFloat = 220
    private let axisWidth: CGFloat = 44
    private let xLabelHeight: CGFloat = 18
    private let maxY: Double = MockChartData.maxY

    var body: some View {
        VStack(alignment: .leading, spacing: MockSpacing.md) {
            chart
                .frame(height: chartHeight)
            targetLegend
        }
        .padding(MockSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: MockSpacing.cornerRadiusLarge)
                .fill(MockTheme.surface)
        )
        .mockSoftShadow()
    }

    // MARK: - Chart

    private var chart: some View {
        GeometryReader { geo in
            let plotWidth = geo.size.width - axisWidth
            let plotHeight = geo.size.height - xLabelHeight

            ZStack(alignment: .topLeading) {
                gridAndAxis(plotWidth: plotWidth, plotHeight: plotHeight)
                bars(plotWidth: plotWidth, plotHeight: plotHeight)
                targetRule(plotWidth: plotWidth, plotHeight: plotHeight)
                xLabels(plotWidth: plotWidth, plotHeight: plotHeight)
            }
        }
    }

    private func gridAndAxis(plotWidth: CGFloat, plotHeight: CGFloat) -> some View {
        ForEach([0.0, 80.0, 160.0, 240.0], id: \.self) { value in
            let y = plotHeight * (1 - value / maxY)
            Rectangle()
                .fill(MockTheme.textTertiary.opacity(0.2))
                .frame(width: plotWidth, height: 0.7)
                .offset(y: y)
            Text(axisLabel(value))
                .font(MockFonts.caption2)
                .foregroundStyle(MockTheme.textTertiary)
                .frame(width: axisWidth, alignment: .trailing)
                .offset(x: plotWidth, y: y - 7)
        }
    }

    private func bars(plotWidth: CGFloat, plotHeight: CGFloat) -> some View {
        let slot = plotWidth / CGFloat(MockChartData.points.count)
        let barWidth = slot * 0.42
        return ForEach(MockChartData.points) { point in
            let barHeight = plotHeight * point.value / maxY
            let index = CGFloat(MockChartData.points.firstIndex { $0.id == point.id } ?? 0)
            UnevenRoundedRectangle(
                topLeadingRadius: 3, bottomLeadingRadius: 0,
                bottomTrailingRadius: 0, topTrailingRadius: 3
            )
            .fill(point.isOverTarget ? MockTheme.accent : MockTheme.primary)
            .frame(width: barWidth, height: barHeight)
            .offset(
                x: index * slot + (slot - barWidth) / 2,
                y: plotHeight - barHeight
            )
        }
    }

    private func targetRule(plotWidth: CGFloat, plotHeight: CGFloat) -> some View {
        let y = plotHeight * (1 - MockChartData.dailyTarget / maxY)
        return DashedLine()
            .stroke(MockTheme.accent, style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
            .frame(width: plotWidth, height: 1.5)
            .offset(y: y)
    }

    private func xLabels(plotWidth: CGFloat, plotHeight: CGFloat) -> some View {
        let slot = plotWidth / CGFloat(MockChartData.points.count)
        return ForEach(MockChartData.points) { point in
            let index = CGFloat(MockChartData.points.firstIndex { $0.id == point.id } ?? 0)
            Text(point.dayLabel)
                .font(MockFonts.caption2)
                .foregroundStyle(MockTheme.textTertiary)
                .frame(width: slot)
                .offset(x: index * slot, y: plotHeight + 5)
        }
    }

    private func axisLabel(_ value: Double) -> String {
        let amount = Int(value)
        switch locale {
        case "pt-BR": return "US$ \(amount)"
        case "es-ES": return "\(amount) US$"
        default:      return "$\(amount)"
        }
    }

    // MARK: - Legend

    private var targetLegend: some View {
        HStack(spacing: MockSpacing.sm) {
            HStack(spacing: 3) {
                ForEach(0..<3, id: \.self) { _ in
                    Rectangle()
                        .fill(MockTheme.accent)
                        .frame(width: 5, height: 2)
                }
            }
            Text(L.t("stats.summary.dailyTarget", locale))
                .font(MockFonts.caption)
                .foregroundStyle(MockTheme.textSecondary)
            Spacer()
            Text(MockMoney.s("dailyTarget", locale))
                .font(MockFonts.caption)
                .foregroundStyle(MockTheme.accent)
        }
    }
}

// MARK: - Dashed Line Shape

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}

// MARK: - Category Breakdown Card (mirror of StatsCategoryBreakdown.swift)

struct MockCategoryBreakdownCard: View {
    let locale: String

    var body: some View {
        VStack(spacing: MockSpacing.md) {
            ForEach(MockChartData.categories, id: \.category.id) { item in
                row(item)
            }
        }
        .padding(MockSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: MockSpacing.cornerRadiusLarge)
                .fill(MockTheme.surface)
        )
        .mockSoftShadow()
    }

    private func row(_ item: (category: MockCategory, moneyKey: String, share: Double)) -> some View {
        HStack(spacing: MockSpacing.md) {
            ZStack {
                Circle()
                    .fill(item.category.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: item.category.symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(item.category.color)
            }

            VStack(alignment: .leading, spacing: MockSpacing.xs + 2) {
                HStack(alignment: .firstTextBaseline) {
                    Text(item.category.title(locale))
                        .font(MockFonts.bodyMedium)
                        .foregroundStyle(MockTheme.textPrimary)
                        .lineLimit(1)
                    Spacer(minLength: MockSpacing.sm)
                    Text(MockMoney.s(item.moneyKey, locale))
                        .font(MockFonts.bodyMedium)
                        .foregroundStyle(MockTheme.textPrimary)
                        .lineLimit(1)
                }
                HStack(spacing: MockSpacing.sm) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(MockTheme.surfaceSecondary)
                            Capsule()
                                .fill(item.category.color)
                                .frame(width: geo.size.width * item.share)
                        }
                    }
                    .frame(height: 6)
                    Text("\(Int((item.share * 100).rounded()))%")
                        .font(MockFonts.caption)
                        .foregroundStyle(MockTheme.textSecondary)
                        .frame(width: 40, alignment: .trailing)
                }
            }
        }
        .frame(minHeight: 44)
    }
}
