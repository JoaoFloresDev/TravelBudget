//
//  MockDataProvider.swift
//  TravelBudget
//

import Foundation

/// Sample data for screenshots tooling and previews of logic (never shipped as real data).
enum MockDataProvider {
    struct SampleData {
        let trips: [Trip]
        let expenses: [Expense]
    }

    // MARK: - Sample
    static func sampleData(today: Date = Date()) -> SampleData {
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .day, value: -3, to: today) ?? today
        let end = calendar.date(byAdding: .day, value: 6, to: today) ?? today

        let lisbon = Trip(
            name: "Lisbon",
            emoji: "🇵🇹",
            startDate: start,
            endDate: end,
            homeCurrency: "USD",
            budgetTotal: 1800
        )

        var expenses: [Expense] = []
        let entries: [(Int, Double, String, ExpenseCategory, String)] = [
            (-3, 62.50, "EUR", .food, "Time Out Market"),
            (-3, 38.00, "EUR", .transport, "Airport metro + day pass"),
            (-2, 145.00, "EUR", .lodging, "Alfama guesthouse"),
            (-2, 24.00, "EUR", .activities, "Tram 28 + miradouros"),
            (-1, 55.30, "EUR", .food, "Bairro Alto dinner"),
            (-1, 18.90, "EUR", .shopping, "Cork souvenirs"),
            (0, 12.40, "EUR", .food, "Pastéis de Belém"),
            (0, 30.00, "EUR", .activities, "Jerónimos Monastery")
        ]
        for (offset, amount, currency, category, note) in entries {
            let date = calendar.date(byAdding: .day, value: offset, to: today) ?? today
            let rate = 0.92
            expenses.append(Expense(
                tripId: lisbon.id,
                amount: amount,
                currency: currency,
                amountHome: amount / rate,
                rateUsed: rate,
                rateDate: date,
                category: category,
                note: note,
                date: date,
                paymentMethod: .card
            ))
        }

        return SampleData(trips: [lisbon], expenses: expenses)
    }
}
