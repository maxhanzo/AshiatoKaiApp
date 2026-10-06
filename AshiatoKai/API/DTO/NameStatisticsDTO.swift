//
//  NameStatisticDTO.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

struct NameStatisticsDTO: Decodable {

    let rank: Int
    let nameRomaji: String
    let nameKanji: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case rank = "Rank"
        case nameRomaji = "NameRomaji"
        case nameKanji = "NameKanji"
        case count = "Count"
    }

    func toDomain() -> NameStatistics {
        NameStatistics(
            rank: rank,
            nameRomaji: nameRomaji,
            nameKanji: nameKanji,
            count: count
        )
    }
}
