//
//  SearchRecord.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Foundation

struct SearchRecord: Identifiable, Hashable {
    let id: Int
    let groupID: Int
    let name: String
    let surname: String
    let nameJapanese: String?
    let surnameJapanese: String?
    let year: Int?
    let prefecture: String?
    let shipName: String?
    let destination: String?
    let farm: String?
    let arrivalDate: String?
    let departureDate: String?

    var fullName: String {
        [name, surname].filter { !$0.isEmpty }.joined(separator: " ")
    }

    var japaneseFullName: String? {
        let value = [surnameJapanese, nameJapanese]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined()
        return value.isEmpty ? nil : value
    }
}
