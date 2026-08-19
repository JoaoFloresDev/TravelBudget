//
//  TravelBudgetApp.swift
//  TravelBudget
//

import SwiftUI
import GambitCoreKit

@main
struct TravelBudgetApp: App {
    // MARK: - Properties
    @AppStorage(StorageKeys.appearanceMode) private var appearanceMode = "light"
    @AppStorage(StorageKeys.hasSeenOnboarding) private var hasSeenOnboarding = false

    // MARK: - Init
    init() {
        AppTheme.configure()
        AppTheme.configureNavigationBar()
        ReviewService.shared.minUsesBeforeFirstPrompt = 10
    }

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            Group {
                if hasSeenOnboarding {
                    MainTabView()
                } else {
                    OnboardingView()
                }
            }
            .preferredColorScheme(preferredScheme)
        }
    }

    // MARK: - Helpers
    private var preferredScheme: ColorScheme? {
        switch appearanceMode {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
