//
//  GeolocationError.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

enum GeolocationError: LocalizedError, Equatable {

    case invalidRequest
    case notFound
    case network
    case decoding
    case invalidData
    case server
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "The geolocation request is invalid."

        case .notFound:
            return "Geolocation data could not be found."

        case .network:
            return "Unable to connect to the server."

        case .decoding:
            return "The geolocation data could not be read."

        case .invalidData:
            return "The geolocation data is invalid."

        case .server:
            return "The server could not complete the request."

        case .unknown:
            return "An unexpected error occurred."
        }
    }
}
