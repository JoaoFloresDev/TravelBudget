//
//  MainTabView.swift
//  TravelBudget
//

import SwiftUI
import GambitCoreKit

struct MainTabView: View {
    // MARK: - State
    @StateObject private var store = TripStore.shared

    // MARK: - View Body
    var body: some View {
        TabView {
            TripsHomeView()
                .environmentObject(store)
                .tabItem {
                    Label(String(localized: "tab.trips"), systemImage: "airplane.departure")
                }

            StatsView()
                .environmentObject(store)
                .tabItem {
                    Label(String(localized: "tab.stats"), systemImage: "chart.pie.fill")
                }

            SettingsView()
                .tabItem {
                    Label(String(localized: "tab.settings"), systemImage: "gearshape.fill")
                }
        }
        .tint(AppColors.primary)
    }
}
