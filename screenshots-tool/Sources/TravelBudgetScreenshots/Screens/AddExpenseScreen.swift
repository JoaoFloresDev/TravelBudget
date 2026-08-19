import SwiftUI
import GambitScreenshotKit

// MARK: - Slot 2 — Add Expense (mirror of AddExpenseSheet.swift)
//
// Amount-first form: big "100" + EUR chip, live conversion line, category
// grid (Food selected), note/date/method rows and the teal Save bar.

struct AddExpenseScreen: View {
    let locale: String

    var body: some View {
        ZStack(alignment: .top) {
            MockTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                iOSStatusBar()

                navBar

                VStack(spacing: MockSpacing.lg) {
                    MockAmountCard(locale: locale)
                    MockCategoryGrid(locale: locale)
                    MockOptionRows(locale: locale)
                }
                .padding(.horizontal, MockSpacing.screenPadding)
                .padding(.top, MockSpacing.md)

                Spacer(minLength: 0)

                saveBar
            }
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        MockInlineNavBar(
            title: L.t("expense.form.title.add", locale),
            leading: AnyView(
                Text(L.t("expense.form.cancel", locale))
                    .font(MockFonts.body)
                    .foregroundStyle(MockTheme.textSecondary)
            ),
            trailing: AnyView(
                Text(L.t("expense.form.save", locale))
                    .font(MockFonts.headline)
                    .foregroundStyle(MockTheme.primary)
            )
        )
    }

    // MARK: - Save Bar

    private var saveBar: some View {
        VStack(spacing: 0) {
            Text(L.t("expense.form.save", locale))
                .font(MockFonts.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: MockSpacing.cornerRadius)
                        .fill(MockTheme.primary)
                )
                .padding(.horizontal, MockSpacing.screenPadding)
                .padding(.vertical, MockSpacing.sm)

            MockHomeIndicator(color: .black)
                .padding(.bottom, 8)
        }
        .background(MockTheme.background.opacity(0.96))
    }
}
