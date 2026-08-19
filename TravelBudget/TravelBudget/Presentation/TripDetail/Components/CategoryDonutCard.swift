import SwiftUI
import GambitCoreKit

/// Donut chart of spending by category (Canvas-drawn) with a legend
/// showing symbol, title, amount and share per category.
struct CategoryDonutCard: View {

    // MARK: - Constants
    private enum Layout {
        static let donutSize: CGFloat = 172
        static let lineWidth: CGFloat = 26
    }

    // MARK: - Properties
    let items: [(category: ExpenseCategory, total: Double)]
    let spentTotal: Double
    let homeCurrency: String

    // MARK: - View Body
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(String(localized: "trip.detail.byCategory"))
                .font(AppFonts.headline)
                .foregroundStyle(AppColors.textPrimary)

            HStack {
                Spacer()
                donut
                Spacer()
            }

            legend
        }
        .padding(AppSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.surface)
        )
        .softShadow()
    }

    // MARK: - Subviews
    private var donut: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - Layout.lineWidth / 2
            var startAngle = Angle.degrees(-90)

            for item in items {
                let fraction = spentTotal > 0 ? item.total / spentTotal : 0
                let endAngle = startAngle + .degrees(fraction * 360)
                var path = Path()
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
                context.stroke(
                    path,
                    with: .color(item.category.color),
                    style: StrokeStyle(lineWidth: Layout.lineWidth, lineCap: .butt)
                )
                startAngle = endAngle
            }
        }
        .frame(width: Layout.donutSize, height: Layout.donutSize)
        .overlay(centerLabel)
    }

    private var centerLabel: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(CurrencyCatalog.format(spentTotal, code: homeCurrency, compact: true))
                .font(AppFonts.title3)
                .foregroundStyle(AppColors.textPrimary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(String(localized: "trip.detail.spent"))
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: Layout.donutSize - Layout.lineWidth * 2 - AppSpacing.md)
    }

    private var legend: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(items, id: \.category.id) { item in
                legendRow(item)
            }
        }
    }

    private func legendRow(_ item: (category: ExpenseCategory, total: Double)) -> some View {
        HStack(spacing: AppSpacing.sm) {
            ZStack {
                Circle()
                    .fill(item.category.color.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: item.category.symbol)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(item.category.color)
            }

            Text(item.category.title)
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)

            Spacer(minLength: AppSpacing.sm)

            Text(CurrencyCatalog.format(item.total, code: homeCurrency, compact: true))
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.textPrimary)

            Text(percentText(for: item.total))
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
                .frame(width: 44, alignment: .trailing)
        }
        .frame(minHeight: 36)
    }

    // MARK: - Private Methods
    private func percentText(for total: Double) -> String {
        guard spentTotal > 0 else { return "0%" }
        return "\(Int((total / spentTotal * 100).rounded()))%"
    }
}
