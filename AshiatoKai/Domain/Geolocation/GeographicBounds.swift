//
//  GeographicBounds.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

struct GeographicBounds: Hashable {
    let minimumLongitude: Double
    let minimumLatitude: Double
    let maximumLongitude: Double
    let maximumLatitude: Double
}

extension GeographicBounds {

    init?(
        array: [Double]?
    ) {
        guard let array,
              array.count >= 4 else {
            return nil
        }

        // GeoJSON bbox is:
        // [minLongitude, minLatitude,
        //  maxLongitude, maxLatitude]

        self.init(
            minimumLongitude: array[0],
            minimumLatitude: array[1],
            maximumLongitude: array[2],
            maximumLatitude: array[3]
        )
    }
}
