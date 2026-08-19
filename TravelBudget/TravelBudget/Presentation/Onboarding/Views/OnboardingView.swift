//
//  OnboardingView.swift
//  TravelBudget
//

import SwiftUI
import OnboardingKit
import GambitCoreKit

struct OnboardingView: View {
    // MARK: - State
    @AppStorage(StorageKeys.hasSeenOnboarding) private var hasSeenOnboarding = false

    // MARK: - View Body
    var body: some View {
        OnboardingFeaturePager(
            steps: [
                OnboardingFeatureStep(
                    id: 0,
                    icon: "airplane.departure",
                    gradientTop: AppColors.primary,
                    gradientBottom: AppColors.secondary,
                    title: String(localized: "onboarding.step1.title"),
                    subtitle: String(localized: "onboarding.step1.subtitle")
                ),
                OnboardingFeatureStep(
                    id: 1,
                    icon: "coloncurrencysign.circle.fill",
                    gradientTop: AppColors.primary,
                    gradientBottom: AppColors.secondary,
                    title: String(localized: "onboarding.step2.title"),
                    subtitle: String(localized: "onboarding.step2.subtitle")
                ),
                OnboardingFeatureStep(
                    id: 2,
                    icon: "square.grid.2x2.fill",
                    gradientTop: AppColors.primary,
                    gradientBottom: AppColors.secondary,
                    title: String(localized: "onboarding.step3.title"),
                    subtitle: String(localized: "onboarding.step3.subtitle")
                )
            ],
            nextText: String(localized: "onboarding.next"),
            continueText: String(localized: "onboarding.start"),
            onContinue: {
                hasSeenOnboarding = true
            }
        )
    }
}
