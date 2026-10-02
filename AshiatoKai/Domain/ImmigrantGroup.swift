//
//  ImmigrantGroup.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Foundation

struct ImmigrantGroup: Identifiable, Hashable {
    let groupID: Int
    let destination: String?
    let year: Int?
    let farm: String?
    let arrivalDate: String?
    let departureDate: String?
    let shipName: String?
    let prefectureName: String?
    let immigrants: [ImmigrantGroupMember]

    var id: Int { groupID }
}
