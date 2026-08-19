import SwiftUI
import GambitCoreKit

/// Optional detail rows of the expense form — note, date and payment method.
struct ExpenseOptionRows: View {

    // MARK: - Properties

    @ObservedObject var viewModel: AddExpenseViewModel
    @FocusState.Binding var focusedField: ExpenseFormField?

    // MARK: - View Body

    var body: some View {
        VStack(spacing: 0) {
            noteRow
            divider
            dateRow
            divider
            methodRow
        }
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.surface)
        )
        .softShadow()
    }

    // MARK: - Subviews

    private var divider: some View {
        Divider()
            .padding(.leading, AppSpacing.cardPadding + 24 + AppSpacing.sm)
    }

    private var noteRow: some View {
        HStack(spacing: AppSpacing.sm) {
            rowIcon("text.alignleft")
            TextField(
                String(localized: "expense.form.note.placeholder"),
                text: $viewModel.note
            )
            .font(AppFonts.body)
            .focused($focusedField, equals: .note)
            .foregroundStyle(AppColors.textPrimary)
            .submitLabel(.done)
        }
        .padding(.horizontal, AppSpacing.cardPadding)
        .frame(minHeight: 52)
        .contentShape(Rectangle())
        .onTapGesture { focusedField = .note }
    }

    private var dateRow: some View {
        HStack(spacing: AppSpacing.sm) {
            rowIcon("calendar")
            Text(String(localized: "expense.form.date"))
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textPrimary)
            Spacer(minLength: AppSpacing.sm)
            DatePicker(
                "",
                selection: $viewModel.date,
                displayedComponents: [.date]
            )
            .labelsHidden()
            .datePickerStyle(.compact)
            .tint(AppColors.primary)
        }
        .padding(.horizontal, AppSpacing.cardPadding)
        .frame(minHeight: 52)
        .contentShape(Rectangle())
    }

    private var methodRow: some View {
        HStack(spacing: AppSpacing.sm) {
            rowIcon("creditcard")
            methodButton(
                .cash,
                symbol: "banknote",
                title: String(localized: "expense.form.method.cash")
            )
            methodButton(
                .card,
                symbol: "creditcard",
                title: String(localized: "expense.form.method.card")
            )
        }
        .padding(.horizontal, AppSpacing.cardPadding)
        .padding(.vertical, AppSpacing.sm)
        .frame(minHeight: 60)
    }

    private func methodButton(
        _ method: Expense.PaymentMethod,
        symbol: String,
        title: String
    ) -> some View {
        let isSelected = viewModel.paymentMethod == method
        return Button {
            viewModel.selectPaymentMethod(method)
        } label: {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: symbol)
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(AppFonts.subheadline)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
            .background(
                Capsule().fill(isSelected ? AppColors.primary : AppColors.surfaceSecondary)
            )
            .contentShape(Capsule())
        }
        .pressAnimation()
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }

    private func rowIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 16))
            .foregroundStyle(AppColors.textTertiary)
            .frame(width: 24)
    }
}
