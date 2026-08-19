//
//  TripHeroCard.swift
//  TravelBudget
//

import SwiftUI
import GambitCoreKit

/// Prominent card for the current trip: emoji + name + dates, and either the
/// "safe to spend today" figure with a budget progress bar, or the total spent.
struct TripHeroCard: View {
    // MARK: - Properties
    let trip: Trip
    let summary: BudgetEngine.Summary

    // MARK: - Computed Properties
    private var dateRangeText: String {
        (trip.startDate..<trip.endDate).formatted(date: .abbreviated, time: .omitted)
    }

    private var headlineLabel: String {
        if trip.budgetTotal != nil {
            return summary.safeToSpendToday != nil
                ? String(localized: "trips.hero.safeToday")
                : String(localized: "trips.hero.remaining")
        }
        return String(localized: "trips.hero.spent")
    }

    private var headlineValue: Double {
        if trip.budgetTotal != nil {
            return summary.safeToSpendToday ?? summary.remaining ?? 0
        }
        return summary.spentTotal
    }

    private var headlineColor: Color {
        guard trip.budgetTotal != nil else { return AppColors.textPrimary }
        return headlineValue < 0 ? AppColors.error : AppColors.primary
    }

    private var budgetProgress: Double {
        guard let budget = trip.budgetTotal, budget > 0 else { return 0 }
        return min(max(summary.spentTotal / budget, 0), 1)
    }

    private var progressColor: Color {
        if budgetProgress >= 1 { return AppColors.error }
        if budgetProgress >= 0.85 { return AppColors.warning }
        return AppColors.primary
    }

    // MARK: - View Body
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            header

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(headlineLabel.uppercased())
                    .font(AppFonts.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textSecondary)
                Text(CurrencyCatalog.format(headlineValue, code: trip.homeCurrency))
                    .font(AppFonts.title)
                    .foregroundStyle(headlineColor)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }

            if trip.budgetTotal != nil {
                budgetSection
            }
        }
        .padding(AppSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge, style: .continuous)
                .fill(AppColors.surface)
        )
        .elevatedShadow()
        .contentShape(Rectangle())
    }

    // MARK: - Subviews
    private var header: some View {
        HStack(spacing: AppSpacing.md) {
            Text(trip.emoji)
                .font(.system(size: 26))
                .frame(width: 48, height: 48)
                .background(Circle().fill(AppColors.primary.opacity(0.1)))

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(trip.name)
                    .font(AppFonts.title3)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)
                Text(dateRangeText)
                    .font(AppFonts.footnote)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer(minLength: AppSpacing.sm)

            TripStatusChip(trip: trip)
        }
    }

    private var budgetSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppColors.surfaceSecondary)
                    Capsule()
                        .fill(progressColor)
                        .frame(width: max(geometry.size.width * budgetProgress, budgetProgress > 0 ? 8 : 0))
                }
            }
            .frame(height: 8)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: budgetProgress)

            HStack {
                footerItem(
                    label: String(localized: "trips.hero.spent"),
                    value: summary.spentTotal,
                    alignment: .leading
                )
                Spacer()
                footerItem(
                    label: String(localized: "trips.hero.budget"),
                    value: trip.budgetTotal ?? 0,
                    alignment: .trailing
                )
            }
        }
    }

    private func footerItem(label: String, value: Double, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 2) {
            Text(label)
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textTertiary)
            Text(CurrencyCatalog.format(value, code: trip.homeCurrency, compact: true))
                .font(AppFonts.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(AppColors.textSecondary)
        }
    }
}
