//
//  ImmigrantGroupMemberDTO.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Foundation

struct ImmigrantGroupMemberDTO: Decodable {
    let immigrantID: Int
    let nameRomaji: String?
    let surnameRomaji: String?
    let surnameKanji: String?
    let nameKanji: String?

    enum CodingKeys: String, CodingKey {
        case immigrantID
        case nameRomaji = "NameRomaji"
        case surnameRomaji = "SurnameRomaji"
        case surnameKanji = "SurnameKanji"
        case nameKanji = "NameKanji"
    }
}

extension ImmigrantGroupMemberDTO {
    func toDomain() -> ImmigrantGroupMember {
        ImmigrantGroupMember(
            immigrantID: immigrantID,
            nameRomaji: nameRomaji,
            surnameRomaji: surnameRomaji,
            surnameKanji: surnameKanji,
            nameKanji: nameKanji
        )
    }
}
