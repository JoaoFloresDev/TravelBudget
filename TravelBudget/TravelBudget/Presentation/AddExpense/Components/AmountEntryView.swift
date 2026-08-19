import SwiftUI
import GambitCoreKit

/// Big amount entry card — large monospaced field, currency chip,
/// live conversion line (tappable to edit rate) and manual-rate fallback.
struct AmountEntryView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: AddExpenseViewModel
    @FocusState.Binding var focusedField: ExpenseFormField?
    let onEditRate: () -> Void

    // MARK: - View Body

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            amountRow
            if let line = viewModel.conversionLineText {
                conversionRow(line)
            }
            if viewModel.showsManualRateEntry {
                manualRateRow
            }
        }
        .padding(AppSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.surface)
        )
        .softShadow()
    }

    // MARK: - Subviews

    private var amountRow: some View {
        HStack(alignment: .center, spacing: AppSpacing.sm) {
            TextField(
                String(localized: "expense.form.amount.placeholder"),
                text: $viewModel.amountText
            )
            .font(AppFonts.timerLarge)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            .focused($focusedField, equals: .amount)
            .foregroundStyle(AppColors.textPrimary)
            .minimumScaleFactor(0.5)
            .frame(minHeight: 56)

            CurrencyMenuChip(viewModel: viewModel)
        }
        .contentShape(Rectangle())
        .onTapGesture { focusedField = .amount }
    }

    private func conversionRow(_ line: String) -> some View {
        Button(action: onEditRate) {
            HStack(spacing: AppSpacing.xs) {
                Text(line)
                    .font(AppFonts.footnote)
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(AppColors.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .pressAnimation()
    }

    private var manualRateRow: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.warning)
                Text(String(localized: "expense.form.rate.unavailable"))
                    .font(AppFonts.footnote)
                    .foregroundStyle(AppColors.warning)
            }

            HStack(spacing: AppSpacing.sm) {
                Text(String(
                    format: String(localized: "expense.form.rate.manual.label"),
                    viewModel.homeCurrency
                ))
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.textSecondary)

                TextField(
                    String(localized: "expense.form.rate.manual.placeholder"),
                    text: $viewModel.manualRateText
                )
                .font(AppFonts.bodyMedium)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: .manualRate)
                .foregroundStyle(AppColors.textPrimary)
                .onChange(of: viewModel.manualRateText) {
                    viewModel.applyManualRate()
                }

                Text(viewModel.currencyCode)
                    .font(AppFonts.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(.horizontal, AppSpacing.sm)
            .frame(minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.cornerRadius)
                    .fill(AppColors.surfaceSecondary)
            )
            .contentShape(Rectangle())
            .onTapGesture { focusedField = .manualRate }
        }
    }
}
