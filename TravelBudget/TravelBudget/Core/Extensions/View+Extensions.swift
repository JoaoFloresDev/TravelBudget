//
//  View+Extensions.swift
//  TravelBudget
//

import SwiftUI

extension View {
    // MARK: - Shadows (black only — never colored)
    func softShadow() -> some View {
        shadow(color: .black.opacity(0.05), radius: 6, y: 2)
    }

    func elevatedShadow() -> some View {
        shadow(color: .black.opacity(0.08), radius: 10, y: 4)
    }
}
