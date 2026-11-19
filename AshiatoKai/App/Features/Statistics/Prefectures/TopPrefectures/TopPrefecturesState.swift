//
//  TopPrefecturesState.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

enum TopPrefecturesState {
    case idle
    case loading
    case loaded([PrefectureStatistics])
    case empty
    case failed(String)
}
