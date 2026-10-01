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

// Provisional domain model. These are not assumed to be API field names.
struct SearchRecord: Identifiable, Hashable {
    let id: String
    let name: String
    let surname: String
    let year: Int
    let prefecture: String
    let shipName: String

    var fullName: String { "\(name) \(surname)" }
}

enum SearchError: Error, LocalizedError {
    case unavailable
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .unavailable: return "The search could not be completed. Please try again."
        case .invalidResponse: return "The service returned an unexpected response."
        }
    }
}

protocol SearchRepository {
    func search(criteria: SearchCriteria) -> AnyPublisher<[SearchRecord], SearchError>
}
