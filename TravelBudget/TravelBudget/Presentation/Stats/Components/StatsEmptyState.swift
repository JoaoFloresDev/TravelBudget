//
//  StatsEmptyState.swift
//  TravelBudget
//
//  Reusable empty state for the Stats tab (no trips / no expenses).
//

import SwiftUI
import GambitCoreKit

struct StatsEmptyState: View {

    // MARK: - Properties

    let symbol: String
    let title: String
    let subtitle: String

    // MARK: - View Body

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 88, height: 88)
                Image(systemName: symbol)
                    .font(.system(size: 36, weight: .medium))
                    .foregroundStyle(AppColors.primary)
            }
            Text(title)
                .font(AppFonts.title3)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            Text(subtitle)
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, AppSpacing.xl)
        .frame(maxWidth: .infinity)
    }
}
