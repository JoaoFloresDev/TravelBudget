import SwiftUI
import GambitCoreKit

/// Single expense row — category icon in a colored circle, note (or category
/// title), payment method glyph, and paid + converted amounts on the right.
struct ExpenseRowView: View {

    // MARK: - Properties
    let expense: Expense
    let homeCurrency: String

    // MARK: - Computed Properties
    private var title: String {
        expense.note.isEmpty ? expense.category.title : expense.note
    }

    private var paymentSymbol: String {
        switch expense.paymentMethod {
        case .cash: return "banknote"
        case .card: return "creditcard"
        }
    }

    private var isForeignCurrency: Bool {
        expense.currency != homeCurrency
    }

    // MARK: - View Body
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            categoryIcon

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.bodyMedium)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)

                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: paymentSymbol)
                        .font(.system(size: 11, weight: .medium))
                    Text(expense.category.title)
                        .lineLimit(1)
                }
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            }

            Spacer(minLength: AppSpacing.sm)

            VStack(alignment: .trailing, spacing: 2) {
                Text(CurrencyCatalog.format(expense.amount, code: expense.currency))
                    .font(AppFonts.bodyMedium)
                    .foregroundStyle(AppColors.textPrimary)
                if isForeignCurrency {
                    Text(CurrencyCatalog.format(expense.amountHome, code: homeCurrency))
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .frame(minHeight: 44)
    }

    // MARK: - Subviews
    private var categoryIcon: some View {
        ZStack {
            Circle()
                .fill(expense.category.color.opacity(0.15))
                .frame(width: 40, height: 40)
            Image(systemName: expense.category.symbol)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(expense.category.color)
        }
    }
}
