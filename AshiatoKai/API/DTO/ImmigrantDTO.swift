//
//  ImmigrantDTO.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Foundation

struct ImmigrantDTO: Decodable {
    let immigrantID: Int
    let groupID: Int
    let destination: String?
    let year: Int?
    let farm: String?
    let arrivalDate: String?
    let departureDate: String?
    let shipName: String?
    let prefectureName: String?
    let nameRomaji: String?
    let surnameRomaji: String?
    let surnameKanji: String?
    let nameKanji: String?

    enum CodingKeys: String, CodingKey {
        case immigrantID, groupID
        case destination = "Destination"
        case year = "Year"
        case farm = "Farm"
        case arrivalDate = "ArrivalDate"
        case departureDate = "DepartureDate"
        case shipName = "ShipName"
        case prefectureName = "PrefectureName"
        case nameRomaji = "NameRomaji"
        case surnameRomaji = "SurnameRomaji"
        case surnameKanji = "SurnameKanji"
        case nameKanji = "NameKanji"
    }

    var domainModel: SearchRecord {
        SearchRecord(
            id: immigrantID,
            groupID: groupID,
            name: nameRomaji ?? "",
            surname: surnameRomaji ?? "",
            nameJapanese: nameKanji,
            surnameJapanese: surnameKanji,
            year: year,
            prefecture: prefectureName,
            shipName: shipName,
            destination: destination,
            farm: farm,
            arrivalDate: arrivalDate,
            departureDate: departureDate
        )
    }
}
