//
//  StatsTripPicker.swift
//  TravelBudget
//
//  Horizontal chip row selecting which trip's stats are shown.
//

import SwiftUI
import GambitCoreKit

struct StatsTripPicker: View {

    // MARK: - Properties

    let trips: [Trip]
    let selectedId: UUID?
    let onSelect: (Trip) -> Void

    // MARK: - View Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(trips) { trip in
                    chip(for: trip)
                }
            }
            .padding(.horizontal, AppSpacing.screenPadding)
            .padding(.vertical, AppSpacing.xs)
        }
    }

    // MARK: - Subviews

    private func chip(for trip: Trip) -> some View {
        let isSelected = trip.id == selectedId
        return Button {
            onSelect(trip)
        } label: {
            HStack(spacing: AppSpacing.xs + 2) {
                Text(trip.emoji)
                    .font(AppFonts.subheadline)
                Text(trip.name)
                    .font(AppFonts.bodyMedium)
                    .lineLimit(1)
                    .foregroundStyle(isSelected ? Color.white : AppColors.textPrimary)
            }
            .padding(.horizontal, AppSpacing.md)
            .frame(minHeight: 44)
            .background(
                Capsule()
                    .fill(isSelected ? AppColors.primary : AppColors.surface)
            )
            .overlay(
                Capsule()
                    .strokeBorder(
                        isSelected ? Color.clear : AppColors.textTertiary.opacity(0.25),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .pressAnimation()
        .softShadow()
    }
}
