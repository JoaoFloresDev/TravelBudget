//
//  CurrencyCatalog.swift
//  TravelBudget
//

import Foundation

/// Static catalog of supported currencies for pickers and formatting.
enum CurrencyCatalog {
    struct Entry: Identifiable, Equatable {
        let code: String
        let flag: String
        var id: String { code }

        var localizedName: String {
            Locale.current.localizedString(forCurrencyCode: code) ?? code
        }
    }

    // MARK: - Popular travel currencies (picker order)
    static let all: [Entry] = [
        Entry(code: "USD", flag: "🇺🇸"), Entry(code: "EUR", flag: "🇪🇺"),
        Entry(code: "BRL", flag: "🇧🇷"), Entry(code: "GBP", flag: "🇬🇧"),
        Entry(code: "JPY", flag: "🇯🇵"), Entry(code: "MXN", flag: "🇲🇽"),
        Entry(code: "ARS", flag: "🇦🇷"), Entry(code: "CLP", flag: "🇨🇱"),
        Entry(code: "COP", flag: "🇨🇴"), Entry(code: "PEN", flag: "🇵🇪"),
        Entry(code: "UYU", flag: "🇺🇾"), Entry(code: "PYG", flag: "🇵🇾"),
        Entry(code: "BOB", flag: "🇧🇴"), Entry(code: "CAD", flag: "🇨🇦"),
        Entry(code: "AUD", flag: "🇦🇺"), Entry(code: "NZD", flag: "🇳🇿"),
        Entry(code: "CHF", flag: "🇨🇭"), Entry(code: "CNY", flag: "🇨🇳"),
        Entry(code: "KRW", flag: "🇰🇷"), Entry(code: "THB", flag: "🇹🇭"),
        Entry(code: "VND", flag: "🇻🇳"), Entry(code: "IDR", flag: "🇮🇩"),
        Entry(code: "MYR", flag: "🇲🇾"), Entry(code: "SGD", flag: "🇸🇬"),
        Entry(code: "PHP", flag: "🇵🇭"), Entry(code: "INR", flag: "🇮🇳"),
        Entry(code: "AED", flag: "🇦🇪"), Entry(code: "TRY", flag: "🇹🇷"),
        Entry(code: "EGP", flag: "🇪🇬"), Entry(code: "MAD", flag: "🇲🇦"),
        Entry(code: "ZAR", flag: "🇿🇦"), Entry(code: "SEK", flag: "🇸🇪"),
        Entry(code: "NOK", flag: "🇳🇴"), Entry(code: "DKK", flag: "🇩🇰"),
        Entry(code: "PLN", flag: "🇵🇱"), Entry(code: "CZK", flag: "🇨🇿"),
        Entry(code: "HUF", flag: "🇭🇺"), Entry(code: "RON", flag: "🇷🇴"),
        Entry(code: "ILS", flag: "🇮🇱"), Entry(code: "HKD", flag: "🇭🇰")
    ]

    static func entry(for code: String) -> Entry? {
        all.first { $0.code == code }
    }

    /// Device-locale currency, falling back to USD.
    static var deviceDefault: String {
        let code = Locale.current.currency?.identifier ?? "USD"
        return entry(for: code)?.code ?? "USD"
    }

    // MARK: - Formatting
    static func format(_ value: Double, code: String, compact: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        formatter.maximumFractionDigits = compact && abs(value) >= 1000 ? 0 : 2
        return formatter.string(from: NSNumber(value: value)) ?? "\(code) \(value)"
    }
}
