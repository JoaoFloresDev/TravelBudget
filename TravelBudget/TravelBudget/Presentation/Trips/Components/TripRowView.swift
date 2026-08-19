//
//  TripRowView.swift
//  TravelBudget
//

import SwiftUI
import GambitCoreKit

/// Card row for one trip in the home list: emoji, name, date range, spent/budget, chevron.
struct TripRowView: View {
    // MARK: - Properties
    let trip: Trip
    let spent: Double
    let isPinned: Bool

    // MARK: - Computed Properties
    private var dateRangeText: String {
        (trip.startDate..<trip.endDate).formatted(date: .abbreviated, time: .omitted)
    }

    private var spentText: String {
        CurrencyCatalog.format(spent, code: trip.homeCurrency, compact: true)
    }

    private var budgetText: String? {
        guard let budget = trip.budgetTotal else { return nil }
        return CurrencyCatalog.format(budget, code: trip.homeCurrency, compact: true)
    }

    private var isDimmed: Bool { trip.isPast }

    // MARK: - View Body
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            emojiBadge

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                HStack(spacing: AppSpacing.xs) {
                    Text(trip.name)
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                    if isPinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(AppColors.accent)
                    }
                }
                Text(dateRangeText)
                    .font(AppFonts.footnote)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer(minLength: AppSpacing.sm)

            VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                Text(spentText)
                    .font(AppFonts.bodyMedium)
                    .foregroundStyle(AppColors.textPrimary)
                if let budgetText {
                    Text("/ \(budgetText)")
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textTertiary)
                }
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppColors.textTertiary)
        }
        .padding(AppSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadius, style: .continuous)
                .fill(AppColors.surface)
        )
        .softShadow()
        .opacity(isDimmed ? 0.65 : 1)
        .contentShape(Rectangle())
    }

    // MARK: - Subviews
    private var emojiBadge: some View {
        Text(trip.emoji)
            .font(.system(size: 22))
            .frame(width: 44, height: 44)
            .background(Circle().fill(AppColors.surfaceSecondary))
    }
}
