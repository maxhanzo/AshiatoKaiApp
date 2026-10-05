//
//  Geolocation.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

struct Geolocation: Hashable {

    let name: String
    let nameJapanese: String?

    let geometry: GeographicGeometry
    let capital: GeographicCapital?

    let bounds: GeographicBounds
    let displayBounds: GeographicBounds?
}
