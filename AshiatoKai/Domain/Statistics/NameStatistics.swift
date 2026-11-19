//
//  NameStatistics.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

struct NameStatistics: Identifiable, Hashable {

    let rank: Int
    let nameRomaji: String
    let nameKanji: String
    let count: Int

    var id: String {
        "\(nameRomaji)-\(nameKanji)"
    }
}
