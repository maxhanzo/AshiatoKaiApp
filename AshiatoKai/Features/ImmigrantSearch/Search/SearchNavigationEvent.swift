//
//  SearchNavigationEvent.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Foundation

enum SearchNavigationEvent {
    case showResults([SearchRecord])
    case showDetail(SearchRecord)
}
