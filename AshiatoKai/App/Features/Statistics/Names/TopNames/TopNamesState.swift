//
//  TopNamesState.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Foundation

enum TopNamesState {
    case idle
    case loading
    case loaded([NameStatistics])
    case empty
    case failed(String)
}
