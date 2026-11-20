//
//  TopSurnamesState.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import AshiatoKaiDomain
import Foundation

enum TopSurnamesState {
    case idle
    case loading
    case loaded([SurnameStatistics])
    case empty
    case failed(String)
}
