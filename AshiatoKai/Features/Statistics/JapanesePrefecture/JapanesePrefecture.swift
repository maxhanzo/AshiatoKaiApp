//
//  JapanesePlace.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

struct JapanesePlace: Hashable {
    let databaseName: String
    let displayName: String
    let latitude: Double
    let longitude: Double
    let mapSpan: Double
    let context: Context

    enum Context: Hashable {
        case prefecture
        case historicalTerritory
        case historicalRegion
    }
}
