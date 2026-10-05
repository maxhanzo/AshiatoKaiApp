//
//  ImmigrantGroupMember.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Foundation

struct ImmigrantGroupMember: Identifiable, Hashable {
    let immigrantID: Int
    let nameRomaji: String?
    let surnameRomaji: String?
    let surnameKanji: String?
    let nameKanji: String?

    var id: Int { immigrantID }

    var fullName: String {
        [nameRomaji, surnameRomaji]
            .compactMap { $0 }
            .joined(separator: " ")
    }

    var japaneseFullName: String? {
        let value = [surnameKanji, nameKanji]
            .compactMap { $0 }
            .joined()

        return value.isEmpty ? nil : value
    }
}
