//
//  SearchModels.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import Foundation
import Combine

struct SearchCriteria: Equatable {
    var name = ""
    var surname = ""
    var year: Int?
    var prefecture = ""
    var shipName = ""
}

struct SearchRecord: Identifiable, Hashable {
    let id: Int
    let groupID: Int
    let name: String
    let surname: String
    let nameJapanese: String?
    let surnameJapanese: String?
    let year: Int?
    let prefecture: String?
    let shipName: String?
    let destination: String?
    let farm: String?
    let arrivalDate: String?
    let departureDate: String?

    var fullName: String {
        [name, surname].filter { !$0.isEmpty }.joined(separator: " ")
    }

    var japaneseFullName: String? {
        let value = [surnameJapanese, nameJapanese]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined()
        return value.isEmpty ? nil : value
    }
}

enum SearchError: Error, LocalizedError {
    case invalidRequest(String)
    case unavailable
    case invalidResponse

    init(apiError: APIError) {
        switch apiError {
        case .server(let status, _, let message) where status == 400:
            self = .invalidRequest(message ?? "The search request is invalid.")
        case .decoding, .nonHTTPResponse:
            self = .invalidResponse
        case .transport, .server:
            self = .unavailable
        }
    }

    var errorDescription: String? {
        switch self {
        case .invalidRequest(let message): return message
        case .unavailable: return "The search could not be completed. Please try again."
        case .invalidResponse: return "The service returned an unexpected response."
        }
    }
}

protocol SearchRepository {
    func search(criteria: SearchCriteria) -> AnyPublisher<[SearchRecord], SearchError>
}
