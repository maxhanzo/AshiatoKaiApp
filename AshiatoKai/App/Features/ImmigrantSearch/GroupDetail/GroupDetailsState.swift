//
//  GroupDetailsState.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import AshiatoKaiDomain
import Foundation

enum GroupDetailsState {
    case idle
    case loading
    case loaded(ImmigrantGroup)
    case failed(String)
}
