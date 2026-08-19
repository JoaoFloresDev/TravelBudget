//
//  StatsCategoryBreakdown.swift
//  TravelBudget
//
//  Category list with animated share bars: icon, title, progress, amount + percent.
//

import SwiftUI
import GambitCoreKit

struct StatsCategoryBreakdown: View {

    // MARK: - Properties

    let categories: [CategoryStat]
    let currencyCode: String

    // MARK: - View Body

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(Array(categories.enumerated()), id: \.element.id) { index, stat in
                StatsCategoryRow(stat: stat, currencyCode: currencyCode, index: index)
            }
        }
        .padding(AppSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.surface)
        )
        .softShadow()
    }
}

// MARK: - Row

private struct StatsCategoryRow: View {

    // MARK: - Properties

    let stat: CategoryStat
    let currencyCode: String
    let index: Int

    @State private var animateBar = false

    // MARK: - View Body

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            iconCircle
            VStack(alignment: .leading, spacing: AppSpacing.xs + 2) {
                HStack(alignment: .firstTextBaseline) {
                    Text(stat.category.title)
                        .font(AppFonts.bodyMedium)
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                    Spacer(minLength: AppSpacing.sm)
                    Text(CurrencyCatalog.format(stat.total, code: currencyCode))
                        .font(AppFonts.bodyMedium)
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                HStack(spacing: AppSpacing.sm) {
                    progressBar
                    Text("\(Int((stat.share * 100).rounded()))%")
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(width: 40, alignment: .trailing)
                }
            }
        }
        .frame(minHeight: 44)
        .contentShape(Rectangle())
        .onAppear {
            withAnimation(
                .spring(response: 0.6, dampingFraction: 0.8)
                .delay(Double(index) * 0.06)
            ) {
                animateBar = true
            }
        }
    }

    // MARK: - Subviews

    private var iconCircle: some View {
        ZStack {
            Circle()
                .fill(stat.category.color.opacity(0.15))
                .frame(width: 40, height: 40)
            Image(systemName: stat.category.symbol)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(stat.category.color)
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppColors.surfaceSecondary)
                Capsule()
                    .fill(stat.category.color)
                    .frame(width: geo.size.width * (animateBar ? stat.share : 0))
            }
        }
        .frame(height: 6)
    }
}
