//
//  ExpenseCategory.swift
//  TravelBudget
//

import SwiftUI

enum ExpenseCategory: String, Codable, CaseIterable, Identifiable {
    case food
    case transport
    case lodging
    case activities
    case shopping
    case fees
    case health
    case other

    // MARK: - Identifiable
    var id: String { rawValue }

    // MARK: - Presentation
    var symbol: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "bus.fill"
        case .lodging: return "bed.double.fill"
        case .activities: return "ticket.fill"
        case .shopping: return "bag.fill"
        case .fees: return "creditcard.fill"
        case .health: return "cross.case.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var title: String {
        switch self {
        case .food: return String(localized: "category.food")
        case .transport: return String(localized: "category.transport")
        case .lodging: return String(localized: "category.lodging")
        case .activities: return String(localized: "category.activities")
        case .shopping: return String(localized: "category.shopping")
        case .fees: return String(localized: "category.fees")
        case .health: return String(localized: "category.health")
        case .other: return String(localized: "category.other")
        }
    }

    /// Stable chart color per category, derived from the app palette family.
    var color: Color {
        switch self {
        case .food: return Color(red: 1.00, green: 0.48, blue: 0.27)
        case .transport: return Color(red: 0.05, green: 0.45, blue: 0.54)
        case .lodging: return Color(red: 0.30, green: 0.37, blue: 0.88)
        case .activities: return Color(red: 0.07, green: 0.61, blue: 0.42)
        case .shopping: return Color(red: 0.91, green: 0.63, blue: 0.24)
        case .fees: return Color(red: 0.62, green: 0.36, blue: 0.71)
        case .health: return Color(red: 0.90, green: 0.28, blue: 0.30)
        case .other: return Color(red: 0.55, green: 0.58, blue: 0.62)
        }
    }
}
