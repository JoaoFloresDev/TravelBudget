import SwiftUI
import GambitScreenshotKit

// MARK: - Slot 4 — Trip Detail (mirror of TripDetailView.swift)
//
// Dashboard card (remaining + safe-today chip + progress + day info),
// category donut card and a day section with two expense rows in an
// inset-grouped card, plus the teal add-expense FAB.

struct TripDetailScreen: View {
    let locale: String

    var body: some View {
        ZStack(alignment: .top) {
            MockTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                iOSStatusBar()

                navBar

                VStack(alignment: .leading, spacing: MockSpacing.md) {
                    MockDashboardCard(locale: locale)
                    MockDonutCard(locale: locale)
                    daySection
                }
                .padding(.horizontal, MockSpacing.screenPadding)
                .padding(.top, MockSpacing.sm)

                Spacer(minLength: 0)
            }

            addButtonOverlay
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        MockInlineNavBar(
            title: MockTripData.name(locale),
            leading: AnyView(
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                    Text(L.t("trips.title", locale))
                        .font(MockFonts.body)
                }
                .foregroundStyle(MockTheme.primary)
            ),
            trailing: AnyView(
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 19, weight: .medium))
                    .foregroundStyle(MockTheme.primary)
            )
        )
    }

    // MARK: - Day Section (inset-grouped style rows)

    private var daySection: some View {
        VStack(alignment: .leading, spacing: MockSpacing.xs + 2) {
            HStack {
                Text(MockComposite.dayHeader(locale))
                Spacer()
                Text(MockMoney.s("dayTotal", locale))
            }
            .font(MockFonts.footnote)
            .foregroundStyle(MockTheme.textSecondary)
            .padding(.horizontal, MockSpacing.xs)

            VStack(spacing: 0) {
                MockExpenseRow(
                    category: .food,
                    title: MockComposite.dinnerNote(locale),
                    categoryTitle: MockCategory.food.title(locale),
                    paymentSymbol: "creditcard",
                    paidAmount: MockMoney.s("dinnerPaid", locale),
                    homeAmount: MockMoney.s("dinnerHome", locale)
                )
                .padding(.horizontal, MockSpacing.cardPadding)
                .padding(.vertical, MockSpacing.sm)

                Rectangle()
                    .fill(MockTheme.textTertiary.opacity(0.25))
                    .frame(height: 0.7)
                    .padding(.leading, MockSpacing.cardPadding + 40 + MockSpacing.sm)

                MockExpenseRow(
                    category: .transport,
                    title: MockComposite.tramNote(locale),
                    categoryTitle: MockCategory.transport.title(locale),
                    paymentSymbol: "banknote",
                    paidAmount: MockMoney.s("tramPaid", locale),
                    homeAmount: MockMoney.s("tramHome", locale)
                )
                .padding(.horizontal, MockSpacing.cardPadding)
                .padding(.vertical, MockSpacing.sm)
            }
            .background(
                RoundedRectangle(cornerRadius: MockSpacing.cornerRadius, style: .continuous)
                    .fill(MockTheme.surface)
            )
        }
    }

    // MARK: - Add Button

    private var addButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Circle().fill(MockTheme.primary))
                    .mockElevatedShadow()
            }
        }
        .padding(MockSpacing.lg)
        .frame(width: 440, height: 956)
    }
}
