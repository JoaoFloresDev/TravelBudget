//
//  CurrencyService.swift
//  TravelBudget
//

import Foundation

/// Fetches and caches exchange rates (open.er-api.com, keyless).
/// Rates are stored per base currency; conversions lock the rate on the expense.
final class CurrencyService {
    // MARK: - Types
    struct RateTable: Codable {
        let base: String
        let fetchedAt: Date
        /// Units of [code] per 1 unit of base.
        let rates: [String: Double]
    }

    private struct APIResponse: Decodable {
        let result: String
        let base_code: String
        let rates: [String: Double]
    }

    // MARK: - Singleton
    static let shared = CurrencyService()
    private init() {
        cache = StorageService.shared.load([String: RateTable].self, from: cacheFile) ?? [:]
    }

    // MARK: - State
    private let cacheFile = "rates.json"
    private var cache: [String: RateTable]

    // MARK: - Public API
    /// Cached table for a base currency, if any (stale allowed — offline first).
    func cachedTable(base: String) -> RateTable? {
        cache[base]
    }

    /// Rate: units of `currency` per 1 unit of `base`. nil when unknown.
    func rate(base: String, currency: String) -> Double? {
        if base == currency { return 1 }
        return cache[base]?.rates[currency]
    }

    /// Refreshes the table for `base` when older than `AppConstants.ratesMaxAge`.
    /// Silent failure keeps the cached (possibly stale) table.
    @discardableResult
    func refreshIfNeeded(base: String) async -> RateTable? {
        if let table = cache[base],
           Date().timeIntervalSince(table.fetchedAt) < AppConstants.ratesMaxAge {
            return table
        }
        guard let url = URL(string: AppConstants.ratesEndpoint + base) else { return cache[base] }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(APIResponse.self, from: data)
            guard response.result == "success" else { return cache[base] }
            let table = RateTable(base: response.base_code, fetchedAt: Date(), rates: response.rates)
            cache[base] = table
            StorageService.shared.save(cache, to: cacheFile)
            return table
        } catch {
            return cache[base]
        }
    }

    /// Converts `amount` in `currency` to the `base` (home) currency.
    /// Returns the converted amount and the locked rate (units of currency per 1 base).
    func convertToHome(amount: Double, currency: String, base: String) -> (amountHome: Double, rate: Double, rateDate: Date)? {
        if currency == base { return (amount, 1, Date()) }
        guard let table = cache[base], let rate = table.rates[currency], rate > 0 else { return nil }
        return (amount / rate, rate, table.fetchedAt)
    }
}
