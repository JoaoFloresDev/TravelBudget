//
//  Collection+Safe.swift
//  TravelBudget
//

import Foundation

extension Collection {
    /// Safe index access — returns nil instead of crashing on out-of-bounds.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
