//
//  NewTripSheet.swift
//  TravelBudget
//
//  Modal sheet for creating a new trip or editing an existing one.
//

import SwiftUI
import GambitCoreKit

/// Create/edit trip modal. Pass a trip to edit it; pass nothing to create.
struct NewTripSheet: View {
    // MARK: - Properties
    private let trip: Trip?

    @EnvironmentObject private var store: TripStore
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var emoji: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var currencyCode: String
    @State private var budgetText: String

    @FocusState private var focusedField: Field?

    private enum Field {
        case name
        case budget
    }

    // MARK: - Computed Properties
    private var isEditing: Bool { trip != nil }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool { !trimmedName.isEmpty }

    private var parsedBudget: Double? {
        let normalized = budgetText
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)
        guard let value = Double(normalized), value > 0 else { return nil }
        return value
    }

    private var selectedCurrency: CurrencyCatalog.Entry? {
        CurrencyCatalog.entry(for: currencyCode)
    }

    // MARK: - Init
    init(trip: Trip? = nil) {
        self.trip = trip
        _name = State(initialValue: trip?.name ?? "")
        _emoji = State(initialValue: trip?.emoji ?? "✈️")
        _startDate = State(initialValue: trip?.startDate ?? Date())
        let defaultEnd = Calendar.current.date(byAdding: .day, value: 6, to: Date()) ?? Date()
        _endDate = State(initialValue: trip?.endDate ?? defaultEnd)
        _currencyCode = State(initialValue: trip?.homeCurrency ?? CurrencyCatalog.deviceDefault)
        if let budget = trip?.budgetTotal {
            let isWhole = budget == budget.rounded(.down)
            _budgetText = State(initialValue: isWhole ? String(Int(budget)) : String(budget))
        } else {
            _budgetText = State(initialValue: "")
        }
    }

    // MARK: - View Body
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: AppSpacing.md) {
                        identityCard
                        datesCard
                        moneyCard
                    }
                    .padding(.horizontal, AppSpacing.screenPadding)
                    .padding(.top, AppSpacing.sm)
                    .padding(.bottom, AppSpacing.xxl)
                }
            }
            .navigationTitle(
                isEditing
                    ? String(localized: "trip.form.title.edit")
                    : String(localized: "trip.form.title.new")
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .onChange(of: startDate) { _, newValue in
                if endDate < newValue { endDate = newValue }
            }
        }
    }

    // MARK: - Subviews
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(String(localized: "trip.form.cancel")) { dismiss() }
                .foregroundStyle(AppColors.textSecondary)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(String(localized: "trip.form.save")) { save() }
                .fontWeight(.semibold)
                .foregroundStyle(canSave ? AppColors.primary : AppColors.textTertiary)
                .disabled(!canSave)
        }
    }

    private var identityCard: some View {
        formCard {
            fieldLabel(String(localized: "trip.form.name.label"))
            TextField(String(localized: "trip.form.name.placeholder"), text: $name)
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textPrimary)
                .focused($focusedField, equals: .name)
                .submitLabel(.done)
                .padding(AppSpacing.sm + AppSpacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: AppSpacing.sm + 2, style: .continuous)
                        .fill(AppColors.surfaceSecondary)
                )

            fieldLabel(String(localized: "trip.form.emoji.label"))
                .padding(.top, AppSpacing.xs)
            TripEmojiPicker(selection: $emoji)
        }
    }

    private var datesCard: some View {
        formCard {
            fieldLabel(String(localized: "trip.form.dates.label"))
            DatePicker(
                String(localized: "trip.form.dates.start"),
                selection: $startDate,
                displayedComponents: .date
            )
            .font(AppFonts.body)
            .foregroundStyle(AppColors.textPrimary)
            .frame(minHeight: 44)

            Divider()

            DatePicker(
                String(localized: "trip.form.dates.end"),
                selection: $endDate,
                in: startDate...,
                displayedComponents: .date
            )
            .font(AppFonts.body)
            .foregroundStyle(AppColors.textPrimary)
            .frame(minHeight: 44)
        }
    }

    private var moneyCard: some View {
        formCard {
            fieldLabel(String(localized: "trip.form.currency.label"))
            currencyMenu

            HStack(spacing: AppSpacing.xs) {
                fieldLabel(String(localized: "trip.form.budget.label"))
                Text(String(localized: "trip.form.budget.optional"))
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textTertiary)
            }
            .padding(.top, AppSpacing.xs)

            HStack(spacing: AppSpacing.sm) {
                TextField("0", text: $budgetText)
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textPrimary)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .budget)
                if let value = parsedBudget {
                    Text(CurrencyCatalog.format(value, code: currencyCode))
                        .font(AppFonts.footnote)
                        .foregroundStyle(AppColors.primary)
                        .lineLimit(1)
                }
            }
            .padding(AppSpacing.sm + AppSpacing.xs)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.sm + 2, style: .continuous)
                    .fill(AppColors.surfaceSecondary)
            )

            Text(String(localized: "trip.form.budget.hint"))
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textTertiary)
        }
    }

    private var currencyMenu: some View {
        Menu {
            ForEach(CurrencyCatalog.all, id: \.code) { entry in
                Button {
                    currencyCode = entry.code
                    HapticManager.selection()
                } label: {
                    Text("\(entry.flag) \(entry.code) · \(entry.localizedName)")
                    if entry.code == currencyCode {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            HStack(spacing: AppSpacing.sm) {
                Text(selectedCurrency?.flag ?? "🌐")
                    .font(.system(size: 20))
                Text(currencyCode)
                    .font(AppFonts.bodyMedium)
                    .foregroundStyle(AppColors.textPrimary)
                Text(selectedCurrency?.localizedName ?? "")
                    .font(AppFonts.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColors.textTertiary)
            }
            .padding(AppSpacing.sm + AppSpacing.xs)
            .frame(minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: AppSpacing.sm + 2, style: .continuous)
                    .fill(AppColors.surfaceSecondary)
            )
            .contentShape(Rectangle())
        }
    }

    private func formCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            content()
        }
        .padding(AppSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadius, style: .continuous)
                .fill(AppColors.surface)
        )
        .softShadow()
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(AppFonts.footnote)
            .fontWeight(.medium)
            .foregroundStyle(AppColors.textSecondary)
    }

    // MARK: - Actions
    private func save() {
        guard canSave else { return }

        if var existing = trip {
            existing.name = trimmedName
            existing.emoji = emoji
            existing.startDate = startDate
            existing.endDate = endDate
            existing.homeCurrency = currencyCode
            existing.budgetTotal = parsedBudget
            store.update(existing)
        } else {
            let newTrip = Trip(
                name: trimmedName,
                emoji: emoji,
                startDate: startDate,
                endDate: endDate,
                homeCurrency: currencyCode,
                budgetTotal: parsedBudget
            )
            store.add(newTrip)
        }

        HapticManager.success()
        let base = currencyCode
        Task { await CurrencyService.shared.refreshIfNeeded(base: base) }
        dismiss()
    }
}
