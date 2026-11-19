//
//  NameStatisticsState.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

enum NameStatisticsState {
    case idle
    case loading
    case loaded([NameStatistics])
    case empty
    case failed(String)
}
