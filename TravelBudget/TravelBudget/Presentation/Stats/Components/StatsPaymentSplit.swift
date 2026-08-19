//
//  StatsPaymentSplit.swift
//  TravelBudget
//
//  Two-tile cash vs card totals row.
//

import SwiftUI
import GambitCoreKit

struct StatsPaymentSplit: View {

    // MARK: - Properties

    let cashTotal: Double
    let cardTotal: Double
    let currencyCode: String

    // MARK: - View Body

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            tile(
                symbol: "banknote",
                title: String(localized: "stats.payment.cash"),
                value: CurrencyCatalog.format(cashTotal, code: currencyCode),
                tint: AppColors.success
            )
            tile(
                symbol: "creditcard",
                title: String(localized: "stats.payment.card"),
                value: CurrencyCatalog.format(cardTotal, code: currencyCode),
                tint: AppColors.primary
            )
        }
    }

    // MARK: - Subviews

    private func tile(symbol: String, title: String, value: String, tint: Color) -> some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(tint.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(tint)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(1)
                Text(value)
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            Spacer(minLength: 0)
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
