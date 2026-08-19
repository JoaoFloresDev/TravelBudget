//
//  StorageService.swift
//  TravelBudget
//

import Foundation

/// JSON file persistence in the App Group container (shared with the widget).
final class StorageService {
    // MARK: - Singleton
    static let shared = StorageService()
    private init() {}

    // MARK: - Container
    private var containerURL: URL {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: AppConstants.appGroupId
        ) ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func fileURL(_ name: String) -> URL {
        containerURL.appendingPathComponent(name)
    }

    // MARK: - Codable IO
    func load<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        let url = fileURL(file)
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(type, from: data)
    }

    func save<T: Encodable>(_ value: T, to file: String) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(value) else { return }
        try? data.write(to: fileURL(file), options: .atomic)
    }
}
