//
//  TripStatusChip.swift
//  TravelBudget
//

import SwiftUI
import GambitCoreKit

/// Small capsule chip describing a trip's temporal state (active / upcoming / past).
struct TripStatusChip: View {
    // MARK: - Properties
    let trip: Trip

    // MARK: - Computed Properties
    private var label: String {
        if trip.isActive { return String(localized: "trips.status.active") }
        if trip.isUpcoming { return String(localized: "trips.status.upcoming") }
        return String(localized: "trips.status.past")
    }

    private var color: Color {
        if trip.isActive { return AppColors.success }
        if trip.isUpcoming { return AppColors.primary }
        return AppColors.textTertiary
    }

    // MARK: - View Body
    var body: some View {
        Text(label)
            .font(AppFonts.caption)
            .fontWeight(.semibold)
            .foregroundStyle(color)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xs)
            .background(Capsule().fill(color.opacity(0.12)))
    }
}
