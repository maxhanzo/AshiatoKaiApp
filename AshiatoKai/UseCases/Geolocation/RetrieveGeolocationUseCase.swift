//
//  RetrieveGeolocationUseCase.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Combine
import Foundation

final class RetrieveGeolocationUseCase:
    RetrieveGeolocationUseCaseInterface {

    private let repository: GeolocationRepository

    init(repository: GeolocationRepository) {
        self.repository = repository
    }

    func execute(
        name: String
    ) -> AnyPublisher<Geolocation, GeolocationError> {
        repository.retrieveGeolocation(name: name)
    }
}
