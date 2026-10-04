//
//  GeographicCoordinate.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

struct GeographicCoordinate: Hashable {
    let latitude: Double
    let longitude: Double
}

extension GeographicCoordinate {

    init(
        geoJSONCoordinate values: [Double]
    ) throws {
        guard values.count >= 2 else {
            throw GeolocationError.invalidData
        }

        // GeoJSON coordinates are [longitude, latitude].
        self.init(
            latitude: values[1],
            longitude: values[0]
        )
    }
}
