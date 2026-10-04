//
//  GeolocationRepository.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Combine

protocol GeolocationRepository {
    func retrieveGeolocation(
        name: String
    ) -> AnyPublisher<Geolocation, GeolocationError>
}
