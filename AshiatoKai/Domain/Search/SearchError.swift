//
//  SearchError.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Foundation

enum SearchError: Error, LocalizedError {
    case invalidRequest(String)
    case unavailable
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidRequest(let message):
            return message
        case .unavailable:
            return String(localized: "search.error.unavailable")
        case .invalidResponse:
            return String(localized: "search.error.invalid_response")
        }
    }
}
