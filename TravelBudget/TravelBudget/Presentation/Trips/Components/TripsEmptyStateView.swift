//
//  TripsEmptyStateView.swift
//  TravelBudget
//

import SwiftUI
import GambitCoreKit

/// Empty state for the Trips home: hero illustration, title, subtitle and a create CTA.
struct TripsEmptyStateView: View {
    // MARK: - Properties
    let onCreate: () -> Void

    // MARK: - View Body
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 132, height: 132)
                Circle()
                    .fill(AppColors.primary.opacity(0.14))
                    .frame(width: 100, height: 100)
                Image(systemName: "airplane.departure")
                    .font(.system(size: 44, weight: .medium))
                    .foregroundStyle(AppColors.primary)
            }

            VStack(spacing: AppSpacing.sm) {
                Text(String(localized: "trips.empty.title"))
                    .font(AppFonts.title2)
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                Text(String(localized: "trips.empty.subtitle"))
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, AppSpacing.lg)

            Spacer()

            createButton
        }
        .padding(.horizontal, AppSpacing.screenPadding)
        .padding(.bottom, AppSpacing.xl)
    }

    // MARK: - Subviews
    private var createButton: some View {
        Button(action: onCreate) {
            Text(String(localized: "trips.empty.cta"))
                .font(AppFonts.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: AppSpacing.cornerRadius, style: .continuous)
                        .fill(AppColors.primary)
                )
        }
        .pressAnimation()
    }
}
