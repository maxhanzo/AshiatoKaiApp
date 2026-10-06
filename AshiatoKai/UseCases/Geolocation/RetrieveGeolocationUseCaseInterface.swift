//
//  RetrieveGeolocationUseCaseInterface.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine
import Foundation

protocol RetrieveGeolocationUseCaseInterface {
    func execute(
        name: String
    ) -> AnyPublisher<Geolocation, GeolocationError>
}
