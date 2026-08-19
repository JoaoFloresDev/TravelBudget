import SwiftUI

// MARK: - Shadows (mirror of GambitCoreKit View+Extensions — black only)

extension View {
    func mockSoftShadow() -> some View {
        shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    func mockElevatedShadow() -> some View {
        shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

// MARK: - Trip Hero Card (mirror of TripHeroCard.swift)

struct MockTripHeroCard: View {
    let locale: String

    var body: some View {
        VStack(alignment: .leading, spacing: MockSpacing.md) {
            header

            VStack(alignment: .leading, spacing: MockSpacing.xs) {
                Text(L.t("trips.hero.safeToday", locale).uppercased())
                    .font(MockFonts.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(MockTheme.textSecondary)
                Text(MockMoney.s("safeToday", locale))
                    .font(MockFonts.title)
                    .foregroundStyle(MockTheme.primary)
                    .lineLimit(1)
            }

            budgetSection
        }
        .padding(MockSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: MockSpacing.cornerRadiusLarge, style: .continuous)
                .fill(MockTheme.surface)
        )
        .mockElevatedShadow()
    }

    private var header: some View {
        HStack(spacing: MockSpacing.md) {
            Text(MockTripData.emoji)
                .font(.system(size: 26))
                .frame(width: 48, height: 48)
                .background(Circle().fill(MockTheme.primary.opacity(0.1)))

            VStack(alignment: .leading, spacing: MockSpacing.xs) {
                Text(MockTripData.name(locale))
                    .font(MockFonts.title3)
                    .foregroundStyle(MockTheme.textPrimary)
                    .lineLimit(1)
                Text(MockTripData.dateRange(locale))
                    .font(MockFonts.footnote)
                    .foregroundStyle(MockTheme.textSecondary)
            }

            Spacer(minLength: MockSpacing.sm)

            statusChip
        }
    }

    private var statusChip: some View {
        Text(L.t("trips.status.active", locale))
            .font(MockFonts.caption)
            .fontWeight(.semibold)
            .foregroundStyle(MockTheme.success)
            .padding(.horizontal, MockSpacing.sm)
            .padding(.vertical, MockSpacing.xs)
            .background(Capsule().fill(MockTheme.success.opacity(0.12)))
    }

    private var budgetSection: some View {
        VStack(alignment: .leading, spacing: MockSpacing.sm) {
            MockProgressCapsule(progress: MockTripData.budgetProgress, tint: MockTheme.primary)

            HStack {
                footerItem(
                    label: L.t("trips.hero.spent", locale),
                    value: MockMoney.s("spent", locale),
                    alignment: .leading
                )
                Spacer()
                footerItem(
                    label: L.t("trips.hero.budget", locale),
                    value: MockMoney.s("budgetCompact", locale),
                    alignment: .trailing
                )
            }
        }
    }

    private func footerItem(label: String, value: String, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 2) {
            Text(label)
                .font(MockFonts.caption)
                .foregroundStyle(MockTheme.textTertiary)
            Text(value)
                .font(MockFonts.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(MockTheme.textSecondary)
        }
    }
}

// MARK: - Progress Capsule (shared bar)

struct MockProgressCapsule: View {
    let progress: Double
    let tint: Color
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(MockTheme.surfaceSecondary)
                Capsule()
                    .fill(tint)
                    .frame(width: max(geometry.size.width * progress, 8))
            }
        }
        .frame(height: height)
    }
}

// MARK: - Trip Row (mirror of TripRowView.swift)

struct MockTripRow: View {
    let emoji: String
    let name: String
    let dates: String
    let spent: String
    let budget: String
    var isDimmed = false

    var body: some View {
        HStack(spacing: MockSpacing.md) {
            Text(emoji)
                .font(.system(size: 22))
                .frame(width: 44, height: 44)
                .background(Circle().fill(MockTheme.surfaceSecondary))

            VStack(alignment: .leading, spacing: MockSpacing.xs) {
                Text(name)
                    .font(MockFonts.headline)
                    .foregroundStyle(MockTheme.textPrimary)
                    .lineLimit(1)
                Text(dates)
                    .font(MockFonts.footnote)
                    .foregroundStyle(MockTheme.textSecondary)
            }

            Spacer(minLength: MockSpacing.sm)

            VStack(alignment: .trailing, spacing: MockSpacing.xs) {
                Text(spent)
                    .font(MockFonts.bodyMedium)
                    .foregroundStyle(MockTheme.textPrimary)
                Text("/ \(budget)")
                    .font(MockFonts.caption)
                    .foregroundStyle(MockTheme.textTertiary)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(MockTheme.textTertiary)
        }
        .padding(MockSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: MockSpacing.cornerRadius, style: .continuous)
                .fill(MockTheme.surface)
        )
        .mockSoftShadow()
        .opacity(isDimmed ? 0.65 : 1)
    }
}

// MARK: - Amount Card (mirror of AmountEntryView.swift — amount + conversion)

struct MockAmountCard: View {
    let locale: String

    var body: some View {
        VStack(spacing: MockSpacing.sm) {
            amountRow
            conversionRow
        }
        .padding(MockSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: MockSpacing.cornerRadiusLarge)
                .fill(MockTheme.surface)
        )
        .mockSoftShadow()
    }

    private var amountRow: some View {
        HStack(alignment: .center, spacing: MockSpacing.sm) {
            Text("100")
                .font(MockFonts.timerLarge)
                .foregroundStyle(MockTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(minHeight: 56)

            currencyChip
        }
    }

    private var currencyChip: some View {
        HStack(spacing: MockSpacing.xs) {
            Text("🇪🇺")
                .font(MockFonts.body)
            Text("EUR")
                .font(MockFonts.headline)
                .foregroundStyle(MockTheme.textPrimary)
            Image(systemName: "chevron.down")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(MockTheme.textSecondary)
        }
        .padding(.horizontal, MockSpacing.md)
        .frame(minWidth: 44, minHeight: 44)
        .background(Capsule().fill(MockTheme.surfaceSecondary))
    }

    private var conversionRow: some View {
        HStack(spacing: MockSpacing.xs) {
            Text(MockMoney.s("conversion", locale))
                .font(MockFonts.footnote)
                .foregroundStyle(MockTheme.textSecondary)
                .lineLimit(1)
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: 15))
                .foregroundStyle(MockTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 44)
    }
}

// MARK: - Category Grid (mirror of CategoryGridView.swift — Food selected)

struct MockCategoryGrid: View {
    let locale: String

    private static let columns = Array(
        repeating: GridItem(.flexible(), spacing: MockSpacing.sm),
        count: 4
    )

    var body: some View {
        VStack(alignment: .leading, spacing: MockSpacing.sm) {
            Text(L.t("expense.form.category.title", locale))
                .font(MockFonts.subheadline)
                .foregroundStyle(MockTheme.textSecondary)

            LazyVGrid(columns: Self.columns, spacing: MockSpacing.sm) {
                ForEach(MockCategory.allCases) { category in
                    tile(for: category, isSelected: category == .food)
                }
            }
        }
    }

    private func tile(for category: MockCategory, isSelected: Bool) -> some View {
        VStack(spacing: MockSpacing.xs) {
            Image(systemName: category.symbol)
                .font(.system(size: 20, weight: .semibold))
            Text(category.title(locale))
                .font(MockFonts.caption)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 64)
        .foregroundStyle(isSelected ? .white : MockTheme.textPrimary)
        .background(
            RoundedRectangle(cornerRadius: MockSpacing.cornerRadius)
                .fill(isSelected ? category.color : MockTheme.surface)
        )
    }
}

// MARK: - Option Rows (mirror of ExpenseOptionRows.swift)

struct MockOptionRows: View {
    let locale: String

    var body: some View {
        VStack(spacing: 0) {
            noteRow
            divider
            dateRow
            divider
            methodRow
        }
        .background(
            RoundedRectangle(cornerRadius: MockSpacing.cornerRadiusLarge)
                .fill(MockTheme.surface)
        )
        .mockSoftShadow()
    }

    private var divider: some View {
        Rectangle()
            .fill(MockTheme.textTertiary.opacity(0.25))
            .frame(height: 0.7)
            .padding(.leading, MockSpacing.cardPadding + 24 + MockSpacing.sm)
    }

    private var noteRow: some View {
        HStack(spacing: MockSpacing.sm) {
            rowIcon("text.alignleft")
            Text(L.t("expense.form.note.placeholder", locale))
                .font(MockFonts.body)
                .foregroundStyle(MockTheme.textTertiary)
            Spacer()
        }
        .padding(.horizontal, MockSpacing.cardPadding)
        .frame(minHeight: 52)
    }

    private var dateRow: some View {
        HStack(spacing: MockSpacing.sm) {
            rowIcon("calendar")
            Text(L.t("expense.form.date", locale))
                .font(MockFonts.body)
                .foregroundStyle(MockTheme.textPrimary)
            Spacer(minLength: MockSpacing.sm)
            Text(MockComposite.expenseDate(locale))
                .font(MockFonts.subheadline)
                .foregroundStyle(MockTheme.textPrimary)
                .padding(.horizontal, MockSpacing.md)
                .padding(.vertical, MockSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(MockTheme.surfaceSecondary)
                )
        }
        .padding(.horizontal, MockSpacing.cardPadding)
        .frame(minHeight: 52)
    }

    private var methodRow: some View {
        HStack(spacing: MockSpacing.sm) {
            rowIcon("creditcard")
            methodButton(symbol: "banknote", title: L.t("expense.form.method.cash", locale), isSelected: false)
            methodButton(symbol: "creditcard", title: L.t("expense.form.method.card", locale), isSelected: true)
        }
        .padding(.horizontal, MockSpacing.cardPadding)
        .padding(.vertical, MockSpacing.sm)
        .frame(minHeight: 60)
    }

    private func methodButton(symbol: String, title: String, isSelected: Bool) -> some View {
        HStack(spacing: MockSpacing.xs) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .semibold))
            Text(title)
                .font(MockFonts.subheadline)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 44)
        .foregroundStyle(isSelected ? .white : MockTheme.textPrimary)
        .background(
            Capsule().fill(isSelected ? MockTheme.primary : MockTheme.surfaceSecondary)
        )
    }

    private func rowIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 16))
            .foregroundStyle(MockTheme.textTertiary)
            .frame(width: 24)
    }
}

// MARK: - Trip Dashboard Card (mirror of TripDashboardCard.swift)

struct MockDashboardCard: View {
    let locale: String

    var body: some View {
        VStack(alignment: .leading, spacing: MockSpacing.md) {
            VStack(alignment: .leading, spacing: MockSpacing.xs) {
                Text(L.t("trip.detail.remaining", locale))
                    .font(MockFonts.footnote)
                    .foregroundStyle(MockTheme.textSecondary)
                Text(MockMoney.s("remaining", locale))
                    .font(MockFonts.largeTitle)
                    .foregroundStyle(MockTheme.textPrimary)
                    .lineLimit(1)
            }

            Text(MockComposite.safeTodayChip(locale))
                .font(MockFonts.subheadline)
                .foregroundStyle(MockTheme.primary)
                .padding(.horizontal, MockSpacing.md)
                .padding(.vertical, MockSpacing.sm)
                .background(Capsule().fill(MockTheme.primary.opacity(0.12)))

            VStack(alignment: .leading, spacing: MockSpacing.xs) {
                MockProgressCapsule(progress: MockTripData.budgetProgress, tint: MockTheme.primary)
                HStack {
                    Text(MockMoney.s("spent", locale))
                    Spacer()
                    Text(MockMoney.s("budgetFull", locale))
                }
                .font(MockFonts.caption)
                .foregroundStyle(MockTheme.textSecondary)
            }

            HStack(spacing: MockSpacing.xs) {
                Image(systemName: "calendar")
                    .font(MockFonts.caption)
                Text(MockComposite.daysInfo(locale))
                    .font(MockFonts.footnote)
            }
            .foregroundStyle(MockTheme.textSecondary)
        }
        .padding(MockSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: MockSpacing.cornerRadiusLarge)
                .fill(MockTheme.surface)
        )
        .mockElevatedShadow()
    }
}

// MARK: - Category Donut Card (mirror of CategoryDonutCard.swift)

struct MockDonutCard: View {
    let locale: String

    private let donutSize: CGFloat = 172
    private let lineWidth: CGFloat = 26

    var body: some View {
        VStack(alignment: .leading, spacing: MockSpacing.md) {
            Text(L.t("trip.detail.byCategory", locale))
                .font(MockFonts.headline)
                .foregroundStyle(MockTheme.textPrimary)

            HStack {
                Spacer()
                donut
                Spacer()
            }

            legend
        }
        .padding(MockSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: MockSpacing.cornerRadiusLarge)
                .fill(MockTheme.surface)
        )
        .mockSoftShadow()
    }

    private var donut: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - lineWidth / 2
            var startAngle = Angle.degrees(-90)

            for item in MockChartData.categories {
                let endAngle = startAngle + .degrees(item.share * 360)
                var path = Path()
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
                context.stroke(
                    path,
                    with: .color(item.category.color),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt)
                )
                startAngle = endAngle
            }
        }
        .frame(width: donutSize, height: donutSize)
        .overlay(centerLabel)
    }

    private var centerLabel: some View {
        VStack(spacing: MockSpacing.xs) {
            Text(MockMoney.s("spent", locale))
                .font(MockFonts.title3)
                .foregroundStyle(MockTheme.textPrimary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(L.t("trip.detail.spent", locale))
                .font(MockFonts.caption)
                .foregroundStyle(MockTheme.textSecondary)
        }
        .frame(maxWidth: donutSize - lineWidth * 2 - MockSpacing.md)
    }

    private var legend: some View {
        VStack(spacing: MockSpacing.sm) {
            ForEach(MockChartData.categories, id: \.category.id) { item in
                legendRow(item)
            }
        }
    }

    private func legendRow(_ item: (category: MockCategory, moneyKey: String, share: Double)) -> some View {
        HStack(spacing: MockSpacing.sm) {
            ZStack {
                Circle()
                    .fill(item.category.color.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: item.category.symbol)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(item.category.color)
            }

            Text(item.category.title(locale))
                .font(MockFonts.subheadline)
                .foregroundStyle(MockTheme.textPrimary)
                .lineLimit(1)

            Spacer(minLength: MockSpacing.sm)

            Text(MockMoney.s(item.moneyKey, locale))
                .font(MockFonts.subheadline)
                .foregroundStyle(MockTheme.textPrimary)

            Text("\(Int((item.share * 100).rounded()))%")
                .font(MockFonts.caption)
                .foregroundStyle(MockTheme.textSecondary)
                .frame(width: 44, alignment: .trailing)
        }
        .frame(minHeight: 36)
    }
}

// MARK: - Expense Row (mirror of ExpenseRowView.swift)

struct MockExpenseRow: View {
    let category: MockCategory
    let title: String
    let categoryTitle: String
    let paymentSymbol: String
    let paidAmount: String
    let homeAmount: String

    var body: some View {
        HStack(spacing: MockSpacing.sm) {
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: category.symbol)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(category.color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(MockFonts.bodyMedium)
                    .foregroundStyle(MockTheme.textPrimary)
                    .lineLimit(1)

                HStack(spacing: MockSpacing.xs) {
                    Image(systemName: paymentSymbol)
                        .font(.system(size: 11, weight: .medium))
                    Text(categoryTitle)
                        .lineLimit(1)
                }
                .font(MockFonts.caption)
                .foregroundStyle(MockTheme.textSecondary)
            }

            Spacer(minLength: MockSpacing.sm)

            VStack(alignment: .trailing, spacing: 2) {
                Text(paidAmount)
                    .font(MockFonts.bodyMedium)
                    .foregroundStyle(MockTheme.textPrimary)
                Text(homeAmount)
                    .font(MockFonts.caption)
                    .foregroundStyle(MockTheme.textSecondary)
            }
        }
        .frame(minHeight: 44)
    }
}
