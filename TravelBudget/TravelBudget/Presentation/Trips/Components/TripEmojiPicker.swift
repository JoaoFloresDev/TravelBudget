//
//  TripEmojiPicker.swift
//  TravelBudget
//

import SwiftUI
import GambitCoreKit

/// Horizontal row of preset travel emojis with a selectable circle style.
struct TripEmojiPicker: View {
    // MARK: - Constants
    private static let presets = [
        "✈️", "🏖️", "🏔️", "🗼", "🏝️", "🎒",
        "🚗", "🚄", "🛳️", "🌎", "🎡", "🏛️"
    ]

    // MARK: - Properties
    @Binding var selection: String

    // MARK: - View Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(Self.presets, id: \.self) { emoji in
                    emojiCircle(emoji)
                }
            }
            .padding(.vertical, AppSpacing.xs)
        }
    }

    // MARK: - Subviews
    private func emojiCircle(_ emoji: String) -> some View {
        let isSelected = emoji == selection
        return Button {
            selection = emoji
            HapticManager.selection()
        } label: {
            Text(emoji)
                .font(.system(size: 24))
                .frame(width: 46, height: 46)
                .background(
                    Circle()
                        .fill(isSelected ? AppColors.primary.opacity(0.14) : AppColors.surfaceSecondary)
                )
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? AppColors.primary : .clear, lineWidth: 2)
                )
        }
        .pressAnimation()
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selection)
    }
}
