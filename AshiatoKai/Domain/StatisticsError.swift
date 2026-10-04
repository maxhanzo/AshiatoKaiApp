//
//  StatisticsError.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

enum StatisticsError: Error, LocalizedError {
    case invalidRequest(String)
    case unavailable
    case invalidResponse

    init(apiError: APIError) {
        switch apiError {
        case .server(let status, _, let message) where status == 400:
            self = .invalidRequest(
                message ?? "The statistics request is invalid."
            )

        case .decoding, .nonHTTPResponse:
            self = .invalidResponse

        case .transport, .server:
            self = .unavailable
        }
    }

    var errorDescription: String? {
        switch self {
        case .invalidRequest(let message):
            return message

        case .unavailable:
            return "The statistics could not be loaded. Please try again."

        case .invalidResponse:
            return "The service returned an unexpected response."
        }
    }
}
