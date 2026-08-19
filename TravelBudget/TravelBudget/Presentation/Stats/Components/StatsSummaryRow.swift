//
//  StatsSummaryRow.swift
//  TravelBudget
//
//  Three compact stat tiles: total spent, actual average per day, daily budget target.
//

import SwiftUI
import GambitCoreKit

struct StatsSummaryRow: View {

    // MARK: - Properties

    let spentTotal: Double
    let averagePerDay: Double
    let dailyTarget: Double?
    let currencyCode: String

    // MARK: - View Body

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            tile(
                title: String(localized: "stats.summary.spent"),
                value: CurrencyCatalog.format(spentTotal, code: currencyCode),
                tint: AppColors.primary
            )
            tile(
                title: String(localized: "stats.summary.avgPerDay"),
                value: CurrencyCatalog.format(averagePerDay, code: currencyCode),
                tint: AppColors.secondary
            )
            if let dailyTarget {
                tile(
                    title: String(localized: "stats.summary.dailyTarget"),
                    value: CurrencyCatalog.format(dailyTarget, code: currencyCode),
                    tint: AppColors.accent
                )
            }
        }
    }

    // MARK: - Subviews

    private func tile(title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(value)
                .font(AppFonts.headline)
                .foregroundStyle(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        .padding(AppSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadius)
                .fill(AppColors.surface)
        )
        .softShadow()
    }
}
