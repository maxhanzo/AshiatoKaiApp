//
//  SurnameStatisticsState.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

enum SurnameStatisticsState {
    case idle
    case loading
    case loaded([SurnameStatistics])
    case empty
    case failed(String)
}
