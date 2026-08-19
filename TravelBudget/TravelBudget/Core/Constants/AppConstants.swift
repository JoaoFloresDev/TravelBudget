//
//  AppConstants.swift
//  TravelBudget
//

import Foundation

enum AppConstants {
    // MARK: - Identity
    static let appGroupId = "group.com.gambitstudio.travelbudget"
    static let widgetKind = "TravelBudgetWidget"

    // MARK: - Currency
    /// Free, keyless exchange-rate API (base is interpolated).
    static let ratesEndpoint = "https://open.er-api.com/v6/latest/"
    /// Refresh cached rates after this interval (12h).
    static let ratesMaxAge: TimeInterval = 12 * 60 * 60

    // MARK: - Store
    static let supportURL = "https://gambitstudiotech.com/"
    static let privacyURL = "https://drive.google.com/file/d/147xkp4cekrxhrBYZnzV-J4PzCSqkix7t/view?usp=sharing"
    static let termsURL = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
}
