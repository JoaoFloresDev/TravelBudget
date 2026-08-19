//
//  TripsHomeView.swift
//  TravelBudget
//
//  Trips tab root: current-trip hero, trip sections, create/edit/delete/pin.
//

import SwiftUI
import GambitCoreKit

/// Home screen of the Trips tab. Owns the tab's NavigationStack.
struct TripsHomeView: View {
    // MARK: - Properties
    @EnvironmentObject private var store: TripStore

    @State private var isPresentingNewTrip = false
    @State private var tripBeingEdited: Trip?
    @State private var tripPendingDeletion: Trip?

    // MARK: - Computed Properties
    private var activeTrips: [Trip] {
        store.trips.filter { $0.isActive }.sorted { $0.startDate < $1.startDate }
    }

    private var upcomingTrips: [Trip] {
        store.trips.filter { $0.isUpcoming }.sorted { $0.startDate < $1.startDate }
    }

    private var pastTrips: [Trip] {
        store.trips.filter { $0.isPast }.sorted { $0.endDate > $1.endDate }
    }

    private var pinnedTripId: UUID? {
        UserDefaults.standard.string(forKey: StorageKeys.pinnedTripId)
            .flatMap(UUID.init(uuidString:))
    }

    private var isDeleteDialogPresented: Binding<Bool> {
        Binding(
            get: { tripPendingDeletion != nil },
            set: { if !$0 { tripPendingDeletion = nil } }
        )
    }

    // MARK: - View Body
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                content
            }
            .navigationTitle(String(localized: "trips.title"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar { toolbarContent }
            .navigationDestination(for: Trip.self) { trip in
                TripDetailView(trip: trip)
            }
            .sheet(isPresented: $isPresentingNewTrip) {
                NewTripSheet()
            }
            .sheet(item: $tripBeingEdited) { trip in
                NewTripSheet(trip: trip)
            }
            .confirmationDialog(
                String(localized: "trips.delete.title"),
                isPresented: isDeleteDialogPresented,
                titleVisibility: .visible,
                presenting: tripPendingDeletion
            ) { trip in
                Button(String(localized: "trips.delete.confirm"), role: .destructive) {
                    delete(trip)
                }
                Button(String(localized: "trips.delete.cancel"), role: .cancel) {}
            } message: { _ in
                Text(String(localized: "trips.delete.message"))
            }
            .task {
                if let current = store.currentTrip {
                    await CurrencyService.shared.refreshIfNeeded(base: current.homeCurrency)
                }
            }
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var content: some View {
        if store.trips.isEmpty {
            TripsEmptyStateView { isPresentingNewTrip = true }
        } else {
            tripsList
        }
    }

    private var tripsList: some View {
        List {
            if let current = store.currentTrip {
                heroSection(for: current)
            }
            tripSection(title: String(localized: "trips.section.active"), trips: activeTrips)
            tripSection(title: String(localized: "trips.section.upcoming"), trips: upcomingTrips)
            tripSection(title: String(localized: "trips.section.past"), trips: pastTrips)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .animation(.easeOut(duration: 0.25), value: store.trips)
    }

    private func heroSection(for trip: Trip) -> some View {
        Section {
            ZStack {
                NavigationLink(value: trip) { EmptyView() }.opacity(0)
                TripHeroCard(
                    trip: trip,
                    summary: BudgetEngine.summary(trip: trip, expenses: store.expenses)
                )
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(rowInsets(top: AppSpacing.sm, bottom: AppSpacing.sm))
            .contextMenu { contextMenuItems(for: trip) }
        }
    }

    @ViewBuilder
    private func tripSection(title: String, trips: [Trip]) -> some View {
        if !trips.isEmpty {
            Section {
                ForEach(trips) { trip in
                    row(for: trip)
                }
            } header: {
                Text(title.uppercased())
                    .font(AppFonts.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.textSecondary)
                    .padding(.leading, AppSpacing.xs)
            }
        }
    }

    private func row(for trip: Trip) -> some View {
        ZStack {
            NavigationLink(value: trip) { EmptyView() }.opacity(0)
            TripRowView(
                trip: trip,
                spent: spentTotal(for: trip),
                isPinned: trip.id == pinnedTripId
            )
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(rowInsets(top: AppSpacing.xs + 2, bottom: AppSpacing.xs + 2))
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                tripPendingDeletion = trip
            } label: {
                Label(String(localized: "trips.action.delete"), systemImage: "trash")
            }
            .tint(AppColors.error)
        }
        .contextMenu { contextMenuItems(for: trip) }
    }

    @ViewBuilder
    private func contextMenuItems(for trip: Trip) -> some View {
        Button {
            togglePin(trip)
        } label: {
            if trip.id == pinnedTripId {
                Label(String(localized: "trips.action.unpin"), systemImage: "pin.slash")
            } else {
                Label(String(localized: "trips.action.pin"), systemImage: "pin")
            }
        }
        Button {
            tripBeingEdited = trip
        } label: {
            Label(String(localized: "trips.action.edit"), systemImage: "pencil")
        }
        Button(role: .destructive) {
            tripPendingDeletion = trip
        } label: {
            Label(String(localized: "trips.action.delete"), systemImage: "trash")
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isPresentingNewTrip = true
            } label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.primary)
                    .frame(minWidth: 44, minHeight: 44)
            }
            .accessibilityLabel(String(localized: "trips.action.new"))
        }
    }

    // MARK: - Private Methods
    private func spentTotal(for trip: Trip) -> Double {
        store.expenses(for: trip.id).reduce(0) { $0 + $1.amountHome }
    }

    private func rowInsets(top: CGFloat, bottom: CGFloat) -> EdgeInsets {
        EdgeInsets(
            top: top,
            leading: AppSpacing.screenPadding,
            bottom: bottom,
            trailing: AppSpacing.screenPadding
        )
    }

    // MARK: - Actions
    private func togglePin(_ trip: Trip) {
        let defaults = UserDefaults.standard
        if trip.id == pinnedTripId {
            defaults.removeObject(forKey: StorageKeys.pinnedTripId)
        } else {
            defaults.set(trip.id.uuidString, forKey: StorageKeys.pinnedTripId)
        }
        HapticManager.selection()
        store.objectWillChange.send()
    }

    private func delete(_ trip: Trip) {
        if trip.id == pinnedTripId {
            UserDefaults.standard.removeObject(forKey: StorageKeys.pinnedTripId)
        }
        store.deleteTrip(trip.id)
        HapticManager.warning()
    }
}
