import SwiftUI

// MARK: - Mock Theme
//
// Decoupled copy of TravelBudget's `AppTheme` light palette (see
// TravelBudget/Core/Theme/AppTheme.swift). The screenshots tool runs as a
// macOS executable that imports nothing from the iOS app target, so the
// RGB values are mirrored here. Keep in sync with the real palette.

enum MockTheme {
    // MARK: - App Palette (light)
    static let background       = rgb(0xF7, 0xF6, 0xF2)
    static let surface          = rgb(0xFF, 0xFF, 0xFF)
    static let surfaceSecondary = rgb(0xEF, 0xED, 0xE7)
    static let primary          = rgb(0x0C, 0x74, 0x89)   // ocean teal
    static let secondary        = rgb(0x0A, 0x5A, 0x6A)
    static let accent           = rgb(0xFF, 0x7A, 0x45)   // coral
    static let error            = rgb(0xE5, 0x48, 0x4D)
    static let success          = rgb(0x12, 0x9B, 0x6C)
    static let warning          = rgb(0xE8, 0xA1, 0x3C)
    static let textPrimary      = rgb(0x1B, 0x1D, 0x22)
    static let textSecondary    = rgb(0x6B, 0x72, 0x80)
    static let textTertiary     = rgb(0xA6, 0xAC, 0xB8)

    // MARK: - Marketing Constants (house LOOK)
    /// Solid brand background of ALL 5 prints — deep saturated teal.
    static let marketingBackground = rgb(0x0A, 0x5D, 0x6E)
    /// Breakout border + glow — ALWAYS coral, same on all 5 prints.
    static let breakoutGlow = rgb(0xFF, 0x7A, 0x45)

    // MARK: - Category Colors (mirror of ExpenseCategory.color)
    static let categoryFood       = Color(red: 1.00, green: 0.48, blue: 0.27)
    static let categoryTransport  = Color(red: 0.05, green: 0.45, blue: 0.54)
    static let categoryLodging    = Color(red: 0.30, green: 0.37, blue: 0.88)
    static let categoryActivities = Color(red: 0.07, green: 0.61, blue: 0.42)
    static let categoryShopping   = Color(red: 0.91, green: 0.63, blue: 0.24)
    static let categoryFees       = Color(red: 0.62, green: 0.36, blue: 0.71)
    static let categoryHealth     = Color(red: 0.90, green: 0.28, blue: 0.30)
    static let categoryOther      = Color(red: 0.55, green: 0.58, blue: 0.62)

    // MARK: - Widget Palette (mirror of WidgetPalette, light)
    static let widgetBackground = rgb(0xF7, 0xF6, 0xF2)
    static let widgetTeal       = rgb(0x0C, 0x74, 0x89)
    static let widgetCoral      = rgb(0xFF, 0x7A, 0x45)

    // MARK: - Helpers
    private static func rgb(_ r: Int, _ g: Int, _ b: Int) -> Color {
        Color(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

// MARK: - App Fonts / Spacing (mirror of GambitCoreKit)

enum MockFonts {
    static let largeTitle  = Font.system(size: 34, weight: .bold)
    static let title       = Font.system(size: 28, weight: .bold)
    static let title2      = Font.system(size: 22, weight: .bold)
    static let title3      = Font.system(size: 20, weight: .semibold)
    static let headline    = Font.system(size: 17, weight: .semibold)
    static let body        = Font.system(size: 17, weight: .regular)
    static let bodyMedium  = Font.system(size: 16, weight: .medium)
    static let subheadline = Font.system(size: 15, weight: .regular)
    static let footnote    = Font.system(size: 13, weight: .regular)
    static let caption     = Font.system(size: 12, weight: .regular)
    static let caption2    = Font.system(size: 11, weight: .regular)
    static let timerLarge  = Font.system(size: 48, weight: .bold).monospacedDigit()
}

enum MockSpacing {
    static let xs: CGFloat  = 4
    static let sm: CGFloat  = 8
    static let md: CGFloat  = 16
    static let lg: CGFloat  = 24
    static let xl: CGFloat  = 32
    static let xxl: CGFloat = 48
    static let screenPadding: CGFloat = 20
    static let cardPadding: CGFloat   = 16
    static let cornerRadius: CGFloat  = 14
    static let cornerRadiusLarge: CGFloat = 20
}
