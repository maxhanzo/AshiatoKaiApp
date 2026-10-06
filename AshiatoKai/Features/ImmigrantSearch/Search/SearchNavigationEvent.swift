//
//  SearchNavigationEvent.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Foundation

enum SearchNavigationEvent {
    case showResults([SearchRecord])
    case showDetail(SearchRecord)
    case showContact
}
