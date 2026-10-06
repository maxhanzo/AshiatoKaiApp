//
//  GeolocationFeatureDTO.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

struct GeolocationFeatureDTO: Decodable {

    let type: String
    let properties: Properties
    let geometry: GeolocationGeometryDTO

    struct Properties: Decodable {

        let kind: String?

        let prefectureCode: String?
        let prefectureName: String?
        let prefectureNameJapanese: String?

        let capitalName: String?
        let capitalNameJapanese: String?

        let modernName: String?
        let pointKind: String?

        private enum CodingKeys: String, CodingKey {
            case kind = "Kind"

            case prefectureCode = "PrefectureCode"
            case prefectureName = "PrefectureName"
            case prefectureNameJapanese = "PrefectureNameJapanese"

            case capitalName = "CapitalName"
            case capitalNameJapanese = "CapitalNameJapanese"

            case modernName = "ModernName"
            case pointKind = "PointKind"
        }
    }
    
    func toDomainCapital() throws -> GeographicCapital {
        guard case .point(let coordinates) = geometry else {
            throw GeolocationError.invalidData
        }

        guard let name = properties.capitalName,
              !name.isEmpty else {
            throw GeolocationError.invalidData
        }

        return GeographicCapital(
            name: name,
            nameJapanese: properties.capitalNameJapanese,
            modernName: properties.modernName,
            coordinate: try GeographicCoordinate(
                geoJSONCoordinate: coordinates
            )
        )
    }
}
