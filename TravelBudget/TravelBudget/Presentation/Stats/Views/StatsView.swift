//
//  StatsView.swift
//  TravelBudget
//
//  Stats tab root: trip picker, summary tiles, daily bar chart,
//  category breakdown, payment method split.
//

import SwiftUI
import GambitCoreKit

struct StatsView: View {

    // MARK: - Properties

    @EnvironmentObject private var store: TripStore
    @StateObject private var viewModel = StatsViewModel()

    // MARK: - View Body

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                content
            }
            .navigationTitle(String(localized: "tab.stats"))
            .onAppear { viewModel.onAppear(store: store) }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var content: some View {
        if store.trips.isEmpty {
            StatsEmptyState(
                symbol: "chart.bar.xaxis",
                title: String(localized: "stats.empty.noTrips.title"),
                subtitle: String(localized: "stats.empty.noTrips.subtitle")
            )
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    StatsTripPicker(
                        trips: store.trips,
                        selectedId: viewModel.selectedTrip(in: store)?.id,
                        onSelect: { viewModel.select($0) }
                    )
                    if !viewModel.hasLoadedOnce {
                        loadingSections
                    } else if let trip = viewModel.selectedTrip(in: store) {
                        tripContent(for: trip)
                    }
                }
                .padding(.bottom, AppSpacing.xxl)
            }
        }
    }

    @ViewBuilder
    private func tripContent(for trip: Trip) -> some View {
        let data = viewModel.statsData(for: trip, store: store)
        if data.hasExpenses {
            Group {
                StatsSummaryRow(
                    spentTotal: data.spentTotal,
                    averagePerDay: data.averagePerDay,
                    dailyTarget: data.dailyTarget,
                    currencyCode: trip.homeCurrency
                )

                sectionHeader(String(localized: "stats.section.daily"))
                StatsDailyChart(
                    points: data.dailyPoints,
                    dailyTarget: data.dailyTarget,
                    currencyCode: trip.homeCurrency
                )

                sectionHeader(String(localized: "stats.section.categories"))
                StatsCategoryBreakdown(
                    categories: data.categories,
                    currencyCode: trip.homeCurrency
                )

                sectionHeader(String(localized: "stats.section.payment"))
                StatsPaymentSplit(
                    cashTotal: data.cashTotal,
                    cardTotal: data.cardTotal,
                    currencyCode: trip.homeCurrency
                )
            }
            .padding(.horizontal, AppSpacing.screenPadding)
            .transition(.opacity)
        } else {
            StatsEmptyState(
                symbol: "tray",
                title: String(localized: "stats.empty.noExpenses.title"),
                subtitle: String(localized: "stats.empty.noExpenses.subtitle")
            )
            .padding(.top, AppSpacing.xxl)
            .transition(.opacity)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(AppFonts.headline)
            .foregroundStyle(AppColors.textPrimary)
            .padding(.top, AppSpacing.xs)
    }

    private var loadingSections: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(0..<3, id: \.self) { _ in
                    SkeletonView(height: 76, cornerRadius: AppSpacing.cornerRadius)
                }
            }
            SkeletonView(height: 250, cornerRadius: AppSpacing.cornerRadiusLarge)
            VStack(spacing: AppSpacing.md) {
                ForEach(0..<4, id: \.self) { _ in
                    SkeletonView(height: 44, cornerRadius: AppSpacing.cornerRadius)
                }
            }
        }
        .padding(.horizontal, AppSpacing.screenPadding)
    }
}
