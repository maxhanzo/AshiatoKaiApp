//
//  SurnameStatistics.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

struct SurnameStatistics: Identifiable, Hashable {

    let rank: Int
    let surnameRomaji: String
    let surnameKanji: String
    let count: Int

    var id: String {
        "\(surnameRomaji)-\(surnameKanji)"
    }
}
