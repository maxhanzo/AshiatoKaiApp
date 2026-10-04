//
//  PrefectureStatisticsState.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

enum PrefectureStatisticsState {
    case idle
    case loading
    case loaded([PrefectureStatistics])
    case empty
    case failed(String)
}
