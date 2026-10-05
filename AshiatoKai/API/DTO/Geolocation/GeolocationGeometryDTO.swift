//
//  GeolocationGeometryDTO.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

enum GeolocationGeometryDTO: Decodable {

    case point([Double])
    case polygon([[[Double]]])
    case multiPolygon([[[[Double]]]])

    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }

    private enum GeometryType: String, Decodable {
        case point = "Point"
        case polygon = "Polygon"
        case multiPolygon = "MultiPolygon"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        let type = try container.decode(
            GeometryType.self,
            forKey: .type
        )

        switch type {
        case .point:
            self = .point(
                try container.decode(
                    [Double].self,
                    forKey: .coordinates
                )
            )

        case .polygon:
            self = .polygon(
                try container.decode(
                    [[[Double]]].self,
                    forKey: .coordinates
                )
            )

        case .multiPolygon:
            self = .multiPolygon(
                try container.decode(
                    [[[[Double]]]].self,
                    forKey: .coordinates
                )
            )
        }
    }
    
    func toDomainGeometry() throws -> GeographicGeometry {
        switch self {

        case .polygon(let coordinates):
            return .polygon(
                try coordinates.map { ring in
                    try ring.map { coordinate in
                        try GeographicCoordinate(
                            geoJSONCoordinate: coordinate
                        )
                    }
                }
            )

        case .multiPolygon(let coordinates):
            return .multiPolygon(
                try coordinates.map { polygon in
                    try polygon.map { ring in
                        try ring.map { coordinate in
                            try GeographicCoordinate(
                                geoJSONCoordinate: coordinate
                            )
                        }
                    }
                }
            )

        case .point:
            throw GeolocationError.invalidData
        }
    }
}
