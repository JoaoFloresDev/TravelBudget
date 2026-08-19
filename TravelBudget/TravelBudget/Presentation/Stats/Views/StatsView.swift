//
//  StatsView.swift
//  TravelBudget
//
//  Placeholder shell — implemented in Phase 4 (screen-builder).
//

import SwiftUI
import GambitCoreKit

struct StatsView: View {
    // MARK: - Environment
    @EnvironmentObject private var store: TripStore

    // MARK: - View Body
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                VStack(spacing: AppSpacing.md) {
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(AppColors.primary)
                    Text(String(localized: "stats.empty.title"))
                        .font(AppFonts.title3)
                        .foregroundStyle(AppColors.textPrimary)
                }
            }
            .navigationTitle(String(localized: "tab.stats"))
        }
    }
}
