import SwiftUI
import GambitCoreKit

// MARK: - Form Field

/// Focusable fields of the expense form.
enum ExpenseFormField: Hashable {
    case amount
    case note
    case manualRate
}

/// Modal sheet to create or edit an expense — amount-first, log in three taps.
struct AddExpenseSheet: View {

    // MARK: - Properties

    @StateObject private var viewModel: AddExpenseViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: ExpenseFormField?
    @State private var showRateEditor = false
    @State private var rateEditorText = ""
    @State private var showDeleteConfirm = false

    // MARK: - Computed Properties

    private var navigationTitle: String {
        viewModel.isEditing
            ? String(localized: "expense.form.title.edit")
            : String(localized: "expense.form.title.add")
    }

    // MARK: - Lifecycle

    init(trip: Trip, expense: Expense? = nil) {
        _viewModel = StateObject(wrappedValue: AddExpenseViewModel(trip: trip, expense: expense))
    }

    // MARK: - View Body

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        AmountEntryView(
                            viewModel: viewModel,
                            focusedField: $focusedField,
                            onEditRate: presentRateEditor
                        )
                        CategoryGridView(viewModel: viewModel)
                        ExpenseOptionRows(viewModel: viewModel, focusedField: $focusedField)
                        if viewModel.isEditing {
                            deleteButton
                        }
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)
                    .padding(.top, AppSpacing.md)
                    .padding(.bottom, AppSpacing.xxl)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .safeAreaInset(edge: .bottom) { saveBar }
            .task { await viewModel.refreshRatesIfNeeded() }
            .onAppear { focusAmountSoon() }
            .alert(String(localized: "expense.form.rate.edit.title"), isPresented: $showRateEditor) {
                rateEditorAlertContent
            } message: {
                Text(String(
                    format: String(localized: "expense.form.rate.edit.message"),
                    viewModel.homeCurrency,
                    viewModel.currencyCode
                ))
            }
            .confirmationDialog(
                String(localized: "expense.form.delete.confirm.title"),
                isPresented: $showDeleteConfirm,
                titleVisibility: .visible
            ) {
                deleteConfirmContent
            }
        }
    }

    // MARK: - Subviews

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(String(localized: "expense.form.cancel")) {
                dismiss()
            }
            .foregroundStyle(AppColors.textSecondary)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(String(localized: "expense.form.save")) {
                saveAndDismiss()
            }
            .font(AppFonts.headline)
            .foregroundStyle(viewModel.canSave ? AppColors.primary : AppColors.textTertiary)
            .disabled(!viewModel.canSave)
        }
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button(String(localized: "expense.form.done")) {
                focusedField = nil
            }
            .font(AppFonts.headline)
            .foregroundStyle(AppColors.primary)
        }
    }

    private var saveBar: some View {
        Button {
            saveAndDismiss()
        } label: {
            Text(String(localized: "expense.form.save"))
                .font(AppFonts.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: AppSpacing.cornerRadius)
                        .fill(viewModel.canSave ? AppColors.primary : AppColors.textTertiary)
                )
        }
        .pressAnimation()
        .disabled(!viewModel.canSave)
        .animation(.easeOut(duration: 0.2), value: viewModel.canSave)
        .padding(.horizontal, AppSpacing.screenPadding)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.background.opacity(0.96))
    }

    private var deleteButton: some View {
        Button {
            showDeleteConfirm = true
        } label: {
            Text(String(localized: "expense.form.delete"))
                .font(AppFonts.bodyMedium)
                .foregroundStyle(AppColors.error)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 48)
                .background(
                    RoundedRectangle(cornerRadius: AppSpacing.cornerRadius)
                        .fill(AppColors.surface)
                )
                .contentShape(Rectangle())
        }
        .pressAnimation()
    }

    @ViewBuilder
    private var rateEditorAlertContent: some View {
        TextField(
            String(localized: "expense.form.rate.manual.placeholder"),
            text: $rateEditorText
        )
        .keyboardType(.decimalPad)
        Button(String(localized: "expense.form.rate.edit.apply")) {
            viewModel.overrideRate(text: rateEditorText)
        }
        Button(String(localized: "expense.form.cancel"), role: .cancel) {}
    }

    @ViewBuilder
    private var deleteConfirmContent: some View {
        Button(String(localized: "expense.form.delete.confirm.action"), role: .destructive) {
            viewModel.deleteExpense()
            dismiss()
        }
        Button(String(localized: "expense.form.cancel"), role: .cancel) {}
    }

    // MARK: - Actions

    private func saveAndDismiss() {
        if viewModel.save() {
            dismiss()
        }
    }

    private func presentRateEditor() {
        rateEditorText = viewModel.editableRateText
        showRateEditor = true
    }

    private func focusAmountSoon() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            focusedField = .amount
        }
    }
}
