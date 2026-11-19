//
//  StatisticsError.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

enum StatisticsError: Error, LocalizedError {
    case invalidRequest(String)
    case unavailable
    case invalidResponse

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
