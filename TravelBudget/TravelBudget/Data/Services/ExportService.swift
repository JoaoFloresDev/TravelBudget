//
//  ExportService.swift
//  TravelBudget
//

import Foundation

/// CSV export of a trip's expenses (free — no gate).
enum ExportService {
    // MARK: - CSV
    static func csv(trip: Trip, expenses: [Expense]) -> String {
        var lines = ["date,category,note,amount,currency,rate,amount_home,home_currency,payment_method"]
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let tripExpenses = expenses
            .filter { $0.tripId == trip.id }
            .sorted { $0.date < $1.date }
        for expense in tripExpenses {
            let fields = [
                formatter.string(from: expense.date),
                expense.category.rawValue,
                escape(expense.note),
                String(format: "%.2f", expense.amount),
                expense.currency,
                String(format: "%.6f", expense.rateUsed),
                String(format: "%.2f", expense.amountHome),
                trip.homeCurrency,
                expense.paymentMethod.rawValue
            ]
            lines.append(fields.joined(separator: ","))
        }
        return lines.joined(separator: "\n")
    }

    /// Writes the CSV to a temp file and returns its URL for the share sheet.
    static func csvFileURL(trip: Trip, expenses: [Expense]) -> URL? {
        let content = csv(trip: trip, expenses: expenses)
        let safeName = trip.name.replacingOccurrences(of: "/", with: "-")
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(safeName).csv")
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            return nil
        }
    }

    // MARK: - Helpers
    private static func escape(_ field: String) -> String {
        guard field.contains(",") || field.contains("\"") || field.contains("\n") else { return field }
        return "\"" + field.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    }
}
