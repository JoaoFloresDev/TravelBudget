//
//  AppTheme.swift
//  TravelBudget
//

import SwiftUI
import UIKit
import GambitCoreKit

/// Travel/finance niche palette — light-first, warm off-white with ocean teal + coral.
@MainActor
enum AppTheme {
    // MARK: - Palette
    static func configure() {
        GambitCoreKit.configure(palette: GambitPalette(
            background: Color(light: "#F7F6F2", dark: "#101214"),
            surface: Color(light: "#FFFFFF", dark: "#1B1E21"),
            surfaceSecondary: Color(light: "#EFEDE7", dark: "#24282C"),
            primary: Color(light: "#0C7489", dark: "#2DA4BB"),
            secondary: Color(light: "#0A5A6A", dark: "#1E8195"),
            accent: Color(light: "#FF7A45", dark: "#FF8F63"),
            error: Color(light: "#E5484D", dark: "#FF6369"),
            success: Color(light: "#129B6C", dark: "#2FC98F"),
            warning: Color(light: "#E8A13C", dark: "#F5B45C"),
            textPrimary: Color(light: "#1B1D22", dark: "#F2F3F5"),
            textSecondary: Color(light: "#6B7280", dark: "#9CA3AF"),
            textTertiary: Color(light: "#A6ACB8", dark: "#6B7280")
        ))
    }

    // MARK: - Navigation Bar
    static func configureNavigationBar() {
        let nav = UINavigationBarAppearance()
        nav.configureWithOpaqueBackground()
        nav.backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0x10 / 255, green: 0x12 / 255, blue: 0x14 / 255, alpha: 1)
                : UIColor(red: 0xF7 / 255, green: 0xF6 / 255, blue: 0xF2 / 255, alpha: 1)
        }
        nav.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
    }
}
