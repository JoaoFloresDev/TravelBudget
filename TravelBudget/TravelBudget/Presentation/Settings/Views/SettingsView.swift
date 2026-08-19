//
//  SettingsView.swift
//  TravelBudget
//
//  Standard GambitStudio Settings — Appearance · Language · Rate · Privacy · Terms · Version.
//

import SwiftUI
import GambitCoreKit

struct SettingsView: View {
    // MARK: - State
    @AppStorage(StorageKeys.appearanceMode) private var appearanceMode = "light"

    // MARK: - Computed
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    // MARK: - View Body
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        appearanceSection
                        languageSection
                        aboutSection
                        versionFooter
                    }
                    .padding(AppSpacing.screenPadding)
                }
            }
            .navigationTitle(String(localized: "settings.title"))
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Appearance
    private var appearanceSection: some View {
        card {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                sectionHeader("settings.appearance.title", symbol: "circle.lefthalf.filled")
                Picker(String(localized: "settings.appearance.title"), selection: $appearanceMode) {
                    Text(String(localized: "settings.appearance.light")).tag("light")
                    Text(String(localized: "settings.appearance.dark")).tag("dark")
                    Text(String(localized: "settings.appearance.system")).tag("system")
                }
                .pickerStyle(.segmented)
            }
        }
    }

    // MARK: - Language
    private var languageSection: some View {
        card {
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                row(
                    symbol: "globe",
                    title: String(localized: "settings.language.title"),
                    subtitle: String(localized: "settings.language.subtitle")
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - About
    private var aboutSection: some View {
        card {
            VStack(spacing: 0) {
                Button {
                    ReviewService.shared.promptReviewNow()
                } label: {
                    row(symbol: "star.fill", title: String(localized: "settings.rate.title"))
                }
                .buttonStyle(.plain)

                Divider().padding(.vertical, AppSpacing.sm)

                Link(destination: URL(string: AppConstants.privacyURL) ?? URL(fileURLWithPath: "/")) {
                    row(symbol: "hand.raised.fill", title: String(localized: "settings.privacy.title"))
                }

                Divider().padding(.vertical, AppSpacing.sm)

                Link(destination: URL(string: AppConstants.termsURL) ?? URL(fileURLWithPath: "/")) {
                    row(symbol: "doc.text.fill", title: String(localized: "settings.terms.title"))
                }
            }
        }
    }

    // MARK: - Version
    private var versionFooter: some View {
        Text("TravelBudget \(appVersion)")
            .font(AppFonts.caption)
            .foregroundStyle(AppColors.textTertiary)
            .padding(.top, AppSpacing.sm)
    }

    // MARK: - Building Blocks
    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(AppSpacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
            .softShadow()
    }

    private func sectionHeader(_ key: String.LocalizationValue, symbol: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: symbol)
                .foregroundStyle(AppColors.primary)
            Text(String(localized: key))
                .font(AppFonts.headline)
                .foregroundStyle(AppColors.textPrimary)
        }
    }

    private func row(symbol: String, title: String, subtitle: String? = nil) -> some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: symbol)
                .font(.system(size: 18))
                .foregroundStyle(AppColors.primary)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.bodyMedium)
                    .foregroundStyle(AppColors.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(AppFonts.footnote)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppColors.textTertiary)
        }
        .contentShape(Rectangle())
    }
}
