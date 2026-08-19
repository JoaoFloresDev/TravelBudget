import SwiftUI
import GambitCoreKit

/// Trip detail screen — budget dashboard, category donut and the
/// day-grouped expense list. Pushed from TripsHomeView.
struct TripDetailView: View {

    // MARK: - Properties
    let trip: Trip

    @EnvironmentObject private var store: TripStore
    @StateObject private var viewModel = TripDetailViewModel()
    @State private var isAddingExpense = false
    @State private var isEditingTrip = false
    @State private var editingExpense: Expense?

    // MARK: - Computed Properties
    /// Always read the live trip from the store so edits reflect immediately.
    private var liveTrip: Trip {
        store.trips.first { $0.id == trip.id } ?? trip
    }

    private var expenses: [Expense] {
        store.expenses(for: trip.id)
    }

    private var summary: BudgetEngine.Summary {
        BudgetEngine.summary(trip: liveTrip, expenses: expenses)
    }

    private var daySections: [TripDetailViewModel.DaySection] {
        TripDetailViewModel.daySections(from: expenses)
    }

    private var categoryTotals: [(category: ExpenseCategory, total: Double)] {
        BudgetEngine.byCategory(trip: liveTrip, expenses: expenses).filter { $0.total > 0 }
    }

    // MARK: - View Body
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            if expenses.isEmpty {
                emptyContent
            } else {
                expenseList
            }

            addButtonOverlay
        }
        .navigationTitle(liveTrip.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarMenu }
        .sheet(isPresented: $isAddingExpense) {
            AddExpenseSheet(trip: liveTrip)
        }
        .sheet(item: $editingExpense) { expense in
            AddExpenseSheet(trip: liveTrip, expense: expense)
        }
        .sheet(isPresented: $isEditingTrip) {
            NewTripSheet(trip: liveTrip)
        }
        .task {
            await viewModel.refreshRatesIfNeeded(base: liveTrip.homeCurrency)
        }
    }

    // MARK: - Subviews
    private var emptyContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: AppSpacing.md) {
                TripDashboardCard(
                    trip: liveTrip,
                    summary: summary,
                    dayIndex: TripDetailViewModel.dayIndex(for: liveTrip)
                )
                TripDetailEmptyStateView {
                    openAddExpense()
                }
            }
            .padding(.horizontal, AppSpacing.screenPadding)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.xxl)
        }
    }

    private var expenseList: some View {
        List {
            Group {
                TripDashboardCard(
                    trip: liveTrip,
                    summary: summary,
                    dayIndex: TripDetailViewModel.dayIndex(for: liveTrip)
                )
                if !categoryTotals.isEmpty {
                    CategoryDonutCard(
                        items: categoryTotals,
                        spentTotal: summary.spentTotal,
                        homeCurrency: liveTrip.homeCurrency
                    )
                }
            }
            .listRowInsets(EdgeInsets(
                top: AppSpacing.sm,
                leading: AppSpacing.screenPadding,
                bottom: AppSpacing.sm,
                trailing: AppSpacing.screenPadding
            ))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            ForEach(daySections) { section in
                Section {
                    ForEach(section.expenses) { expense in
                        expenseRow(expense)
                    }
                } header: {
                    daySectionHeader(section)
                }
            }

            Color.clear
                .frame(height: 72)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .environment(\.defaultMinListRowHeight, 44)
        .animation(.easeOut(duration: 0.25), value: expenses)
    }

    private func expenseRow(_ expense: Expense) -> some View {
        Button {
            editingExpense = expense
        } label: {
            ExpenseRowView(expense: expense, homeCurrency: liveTrip.homeCurrency)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(AppColors.surface)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                deleteExpense(expense)
            } label: {
                Label(String(localized: "trip.detail.delete"), systemImage: "trash")
            }
        }
    }

    private func daySectionHeader(_ section: TripDetailViewModel.DaySection) -> some View {
        HStack {
            Text(section.date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated)))
            Spacer()
            Text(CurrencyCatalog.format(section.total, code: liveTrip.homeCurrency))
        }
        .font(AppFonts.footnote)
        .foregroundStyle(AppColors.textSecondary)
        .textCase(nil)
    }

    private var addButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                addButton
            }
        }
        .padding(AppSpacing.lg)
    }

    private var addButton: some View {
        Button {
            openAddExpense()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Circle().fill(AppColors.primary))
        }
        .elevatedShadow()
        .pressAnimation()
        .accessibilityLabel(String(localized: "trip.detail.addExpense"))
    }

    private var toolbarMenu: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button {
                    isEditingTrip = true
                } label: {
                    Label(String(localized: "trip.detail.menu.editTrip"), systemImage: "pencil")
                }

                exportButton

                if let rateInfo = TripDetailViewModel.rateInfoText(trip: liveTrip, expenses: expenses) {
                    Section {
                        Text(rateInfo)
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundStyle(AppColors.primary)
                    .frame(minWidth: 44, minHeight: 44)
            }
        }
    }

    @ViewBuilder
    private var exportButton: some View {
        if !expenses.isEmpty,
           let url = ExportService.csvFileURL(trip: liveTrip, expenses: expenses) {
            ShareLink(item: url) {
                Label(String(localized: "trip.detail.menu.exportCSV"), systemImage: "square.and.arrow.up")
            }
        } else {
            Button {
            } label: {
                Label(String(localized: "trip.detail.menu.exportCSV"), systemImage: "square.and.arrow.up")
            }
            .disabled(true)
        }
    }

    // MARK: - Actions
    private func openAddExpense() {
        HapticManager.impact(.light)
        isAddingExpense = true
    }

    private func deleteExpense(_ expense: Expense) {
        HapticManager.impact(.medium)
        store.deleteExpense(expense.id)
    }
}
