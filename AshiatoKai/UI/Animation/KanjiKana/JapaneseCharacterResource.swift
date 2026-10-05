//
//  JapaneseCharacterResource.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Foundation

enum JapaneseCharacterResource {
    static func filename(
        for character: Character
    ) -> String? {
        guard character.unicodeScalars.count == 1,
              let scalar = character.unicodeScalars.first
        else {
            return nil
        }

        return String(scalar.value)
    }
}
