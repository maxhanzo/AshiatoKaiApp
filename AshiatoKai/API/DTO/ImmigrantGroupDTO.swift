//
//  ImmigrantGroupDTO.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Foundation

struct ImmigrantGroupDTO: Decodable {
    let groupID: Int
    let destination: String?
    let year: Int?
    let farm: String?
    let arrivalDate: String?
    let departureDate: String?
    let shipName: String?
    let prefectureName: String?
    let immigrants: [ImmigrantGroupMemberDTO]

    enum CodingKeys: String, CodingKey {
        case groupID
        case destination = "Destination"
        case year = "Year"
        case farm = "Farm"
        case arrivalDate = "ArrivalDate"
        case departureDate = "DepartureDate"
        case shipName = "ShipName"
        case prefectureName = "PrefectureName"
        case immigrants
    }
}

extension ImmigrantGroupDTO {
    func toDomain() -> ImmigrantGroup {
        ImmigrantGroup(
            groupID: groupID,
            destination: destination,
            year: year,
            farm: farm,
            arrivalDate: arrivalDate,
            departureDate: departureDate,
            shipName: shipName,
            prefectureName: prefectureName,
            immigrants: immigrants.map { $0.toDomain() }
        )
    }
}
