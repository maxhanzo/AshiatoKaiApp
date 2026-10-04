//
//  GeographicGeometry.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

enum GeographicGeometry: Hashable {
    case polygon([[GeographicCoordinate]])
    case multiPolygon([[[GeographicCoordinate]]])
}
