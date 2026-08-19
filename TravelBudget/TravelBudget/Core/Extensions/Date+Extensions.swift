//
//  Date+Extensions.swift
//  TravelBudget
//

import Foundation

extension Date {
    /// Start of day in the current calendar.
    var dayStart: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// Whole days between self and other (inclusive of both endpoints, min 1).
    func inclusiveDays(until other: Date) -> Int {
        let from = dayStart
        let to = other.dayStart
        let days = (Calendar.current.dateComponents([.day], from: from, to: to).day ?? 0) + 1
        return max(1, days)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
