import SwiftUI
import GambitCoreKit

/// Currency selector chip — menu with frequently-used currencies first,
/// then the full CurrencyCatalog list.
struct CurrencyMenuChip: View {

    // MARK: - Properties

    @ObservedObject var viewModel: AddExpenseViewModel

    // MARK: - Computed Properties

    private var selectedEntry: CurrencyCatalog.Entry? {
        CurrencyCatalog.entry(for: viewModel.currencyCode)
    }

    // MARK: - View Body

    var body: some View {
        Menu {
            Section(String(localized: "expense.form.currency.frequent")) {
                ForEach(viewModel.frequentCurrencyCodes, id: \.self) { code in
                    currencyButton(for: code)
                }
            }
            Section(String(localized: "expense.form.currency.all")) {
                ForEach(viewModel.otherCurrencyEntries, id: \.code) { entry in
                    currencyButton(for: entry.code)
                }
            }
        } label: {
            HStack(spacing: AppSpacing.xs) {
                Text(selectedEntry?.flag ?? "")
                    .font(AppFonts.body)
                Text(viewModel.currencyCode)
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textPrimary)
                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(.horizontal, AppSpacing.md)
            .frame(minWidth: 44, minHeight: 44)
            .background(Capsule().fill(AppColors.surfaceSecondary))
            .contentShape(Capsule())
        }
        .pressAnimation()
    }

    // MARK: - Subviews

    private func currencyButton(for code: String) -> some View {
        Button {
            viewModel.selectCurrency(code)
        } label: {
            if code == viewModel.currencyCode {
                Label(menuTitle(for: code), systemImage: "checkmark")
            } else {
                Text(menuTitle(for: code))
            }
        }
    }

    // MARK: - Private Methods

    private func menuTitle(for code: String) -> String {
        guard let entry = CurrencyCatalog.entry(for: code) else { return code }
        return "\(entry.flag) \(entry.code) · \(entry.localizedName)"
    }
}
