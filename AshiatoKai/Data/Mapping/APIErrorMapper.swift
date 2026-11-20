//
//  APIErrorMapper.swift
//  AshiatoKai
//
//  Created by Max Ueda on 19/11/26.
//

import AshiatoKaiDomain
import Foundation

enum APIErrorMapper {
    static func search(_ error: APIError) -> SearchError {
        switch error {
        case let .server(status, _, message) where status == 400:
            return .invalidRequest(
                message ?? String(localized: "search.error.invalid_request")
            )

        case .decoding, .nonHTTPResponse:
            return .invalidResponse

        case .transport, .server:
            return .unavailable
        }
    }

    static func statistics(_ error: APIError) -> StatisticsError {
        switch error {
        case let .server(status, _, message) where status == 400:
            return .invalidRequest(
                message ?? "The statistics request is invalid."
            )

        case .decoding, .nonHTTPResponse:
            return .invalidResponse

        case .transport, .server:
            return .unavailable
        }
    }
}
