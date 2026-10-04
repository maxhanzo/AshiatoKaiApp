//
//  PrefectureDetailState.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Foundation

enum PrefectureDetailState {
    case idle
    case loading
    case loaded(Geolocation)
    case failed(String)
}
