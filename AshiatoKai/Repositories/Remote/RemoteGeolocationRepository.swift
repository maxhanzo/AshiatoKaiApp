//
//  RemoteGeolocationRepository.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine
import Foundation

final class RemoteGeolocationRepository: GeolocationRepository {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func retrieveGeolocation(
        name: String
    ) -> AnyPublisher<Geolocation, GeolocationError> {
        let request = AshiatoKaiAPI.geolocation(
            name: name
        )

        return apiClient
            .execute(
                request,
                as: GeolocationFeatureCollectionDTO.self
            )
            .tryMap { dto in
                try dto.toDomain() 
            }
            .mapError { error -> GeolocationError in
                if let geolocationError = error as? GeolocationError {
                    return geolocationError
                }

                guard let apiError = error as? APIError else {
                    return .unknown
                }

                switch apiError {
                case .transport:
                    return .network

                case .nonHTTPResponse:
                    return .network

                case .server(let status, _, _):
                    switch status {
                    case 404:
                        return .notFound

                    case 400..<500:
                        return .invalidRequest

                    default:
                        return .server
                    }

                case .decoding:
                    return .decoding
                }
            }
            .eraseToAnyPublisher()
    }
}
