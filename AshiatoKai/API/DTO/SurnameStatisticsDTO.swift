//
//  SurnameStatisticDTO.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

struct SurnameStatisticsDTO: Decodable {

    let rank: Int
    let surnameRomaji: String
    let surnameKanji: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case rank = "Rank"
        case surnameRomaji = "SurnameRomaji"
        case surnameKanji = "SurnameKanji"
        case count = "Count"
    }

    func toDomain() -> SurnameStatistics {
        SurnameStatistics(
            rank: rank,
            surnameRomaji: surnameRomaji,
            surnameKanji: surnameKanji,
            count: count
        )
    }
}
