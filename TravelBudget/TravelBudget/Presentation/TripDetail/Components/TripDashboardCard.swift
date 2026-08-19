import SwiftUI
import GambitCoreKit

/// Dashboard header card — remaining budget (or spent total when no budget),
/// safe-to-spend-today chip, budget progress bar and trip day info.
struct TripDashboardCard: View {

    // MARK: - Properties
    let trip: Trip
    let summary: BudgetEngine.Summary
    let dayIndex: Int

    // MARK: - Computed Properties
    private var headlineLabel: String {
        summary.remaining != nil
            ? String(localized: "trip.detail.remaining")
            : String(localized: "trip.detail.spent")
    }

    private var headlineAmount: String {
        if let remaining = summary.remaining {
            return CurrencyCatalog.format(remaining, code: trip.homeCurrency)
        }
        return CurrencyCatalog.format(summary.spentTotal, code: trip.homeCurrency)
    }

    private var progressFraction: Double? {
        guard let budget = trip.budgetTotal, budget > 0 else { return nil }
        return min(max(summary.spentTotal / budget, 0), 1)
    }

    private var isOverBudget: Bool {
        guard let budget = trip.budgetTotal else { return false }
        return summary.spentTotal > budget
    }

    private var daysInfoText: String {
        if trip.isUpcoming {
            return String(localized: "trip.detail.upcoming")
        }
        if trip.isPast {
            return String(localized: "trip.detail.ended")
        }
        var text = String(localized: "trip.detail.dayOfTotal \(dayIndex) \(trip.totalDays)")
        if let daysLeft = summary.daysLeft, daysLeft > 0 {
            text += " · " + String(localized: "trip.detail.daysLeft \(daysLeft)")
        }
        return text
    }

    // MARK: - View Body
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            headline
            safeToSpendChip
            if progressFraction != nil {
                progressSection
            }
            daysInfo
        }
        .padding(AppSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.surface)
        )
        .elevatedShadow()
    }

    // MARK: - Subviews
    private var headline: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(headlineLabel)
                .font(AppFonts.footnote)
                .foregroundStyle(AppColors.textSecondary)
            Text(headlineAmount)
                .font(AppFonts.largeTitle)
                .foregroundStyle(isOverBudget ? AppColors.error : AppColors.textPrimary)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private var safeToSpendChip: some View {
        if let safeToday = summary.safeToSpendToday {
            if safeToday > 0 {
                chip(
                    text: String(
                        localized: "trip.detail.safeToday \(CurrencyCatalog.format(safeToday, code: trip.homeCurrency))"
                    ),
                    color: AppColors.primary
                )
            } else {
                chip(
                    text: String(localized: "trip.detail.overToday"),
                    color: AppColors.accent
                )
            }
        } else if summary.spentToday > 0 {
            chip(
                text: String(
                    localized: "trip.detail.todaySpent \(CurrencyCatalog.format(summary.spentToday, code: trip.homeCurrency))"
                ),
                color: AppColors.primary
            )
        }
    }

    private func chip(text: String, color: Color) -> some View {
        Text(text)
            .font(AppFonts.subheadline)
            .foregroundStyle(color)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(Capsule().fill(color.opacity(0.12)))
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppColors.surfaceSecondary)
                    Capsule()
                        .fill(isOverBudget ? AppColors.accent : AppColors.primary)
                        .frame(width: geometry.size.width * (progressFraction ?? 0))
                }
            }
            .frame(height: 8)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: progressFraction)

            HStack {
                Text(CurrencyCatalog.format(summary.spentTotal, code: trip.homeCurrency))
                Spacer()
                if let budget = trip.budgetTotal {
                    Text(CurrencyCatalog.format(budget, code: trip.homeCurrency))
                }
            }
            .font(AppFonts.caption)
            .foregroundStyle(AppColors.textSecondary)
        }
    }

    private var daysInfo: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "calendar")
                .font(AppFonts.caption)
            Text(daysInfoText)
                .font(AppFonts.footnote)
        }
        .foregroundStyle(AppColors.textSecondary)
    }
}
