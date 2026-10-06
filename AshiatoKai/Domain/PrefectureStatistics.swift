//
//  PrefectureStatistics.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

struct PrefectureStatistics: Identifiable, Hashable {

    let rank: Int
    let prefectureName: String
    let count: Int

    var id: String {
        prefectureName
    }
}
