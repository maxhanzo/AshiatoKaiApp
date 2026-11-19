//
//  PrefectureStatisticDTO.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

struct PrefectureStatisticsDTO: Decodable {

    let rank: Int
    let prefectureName: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case rank = "Rank"
        case prefectureName = "PrefectureName"
        case count = "Count"
    }

    func toDomain() -> PrefectureStatistics {
        PrefectureStatistics(
            rank: rank,
            prefectureName: prefectureName,
            count: count
        )
    }
}
