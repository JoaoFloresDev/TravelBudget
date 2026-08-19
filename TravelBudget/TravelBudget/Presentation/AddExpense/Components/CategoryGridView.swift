import SwiftUI
import GambitCoreKit

/// Category picker grid — 2 rows x 4 tiles, one per ExpenseCategory,
/// selected tile filled with the category color.
struct CategoryGridView: View {

    // MARK: - Constants

    private static let columns = Array(
        repeating: GridItem(.flexible(), spacing: AppSpacing.sm),
        count: 4
    )

    // MARK: - Properties

    @ObservedObject var viewModel: AddExpenseViewModel

    // MARK: - View Body

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(String(localized: "expense.form.category.title"))
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.textSecondary)

            LazyVGrid(columns: Self.columns, spacing: AppSpacing.sm) {
                ForEach(ExpenseCategory.allCases) { category in
                    tile(for: category)
                }
            }
        }
    }

    // MARK: - Subviews

    private func tile(for category: ExpenseCategory) -> some View {
        let isSelected = viewModel.category == category
        return Button {
            viewModel.selectCategory(category)
        } label: {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: category.symbol)
                    .font(.system(size: 20, weight: .semibold))
                Text(category.title)
                    .font(AppFonts.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.cornerRadius)
                    .fill(isSelected ? category.color : AppColors.surface)
            )
            .contentShape(RoundedRectangle(cornerRadius: AppSpacing.cornerRadius))
        }
        .pressAnimation()
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
