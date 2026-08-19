import SwiftUI
import GambitCoreKit

/// Friendly empty state shown when the trip has no expenses yet.
struct TripDetailEmptyStateView: View {

    // MARK: - Properties
    let onAddExpense: () -> Void

    // MARK: - View Body
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.12))
                    .frame(width: 88, height: 88)
                Image(systemName: "banknote")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundStyle(AppColors.primary)
            }
            .padding(.top, AppSpacing.xl)

            Text(String(localized: "trip.detail.empty.title"))
                .font(AppFonts.title3)
                .foregroundStyle(AppColors.textPrimary)

            Text(String(localized: "trip.detail.empty.subtitle"))
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.lg)

            Button {
                onAddExpense()
            } label: {
                Text(String(localized: "trip.detail.empty.cta"))
                    .font(AppFonts.headline)
                    .foregroundStyle(.white)
                    .frame(minWidth: 200, minHeight: 50)
                    .background(Capsule().fill(AppColors.primary))
            }
            .pressAnimation()
            .padding(.top, AppSpacing.sm)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.lg)
    }
}
