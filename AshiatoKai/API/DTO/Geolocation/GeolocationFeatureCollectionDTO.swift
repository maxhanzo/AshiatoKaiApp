//
//  GeolocationFeatureCollectionDTO.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

struct GeolocationFeatureCollectionDTO: Decodable {
    let type: String
    let bbox: [Double]?
    let displayBbox: [Double]?
    let features: [GeolocationFeatureDTO]
    
    func toDomain() throws -> Geolocation {

        guard let boundaryFeature = features.first(where: {
            switch $0.geometry {
            case .polygon, .multiPolygon:
                return true

            case .point:
                return false
            }
        }) else {
            throw GeolocationError.invalidData
        }

        let geometry = try boundaryFeature.geometry.toDomainGeometry()

        let capitalFeature = features.first(where: {
            guard $0.properties.kind?.lowercased() == "capital" else {
                return false
            }

            if case .point = $0.geometry {
                return true
            }

            return false
        })

        let capital = try capitalFeature?.toDomainCapital()

        guard let bounds = GeographicBounds(array: bbox) else {
            throw GeolocationError.invalidData
        }

        let displayBounds = GeographicBounds(
            array: displayBbox
        )

        let name =
            boundaryFeature.properties.prefectureName
            ?? capitalFeature?.properties.prefectureName

        guard let name, !name.isEmpty else {
            throw GeolocationError.invalidData
        }

        return Geolocation(
            name: name,
            nameJapanese:
                boundaryFeature.properties.prefectureNameJapanese,
            geometry: geometry,
            capital: capital,
            bounds: bounds,
            displayBounds: displayBounds
        )
    }
}
