//
//  JapaneseNameWritingViewModel.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Combine
import Foundation

@MainActor
final class JapaneseNameWritingViewModel: ObservableObject {

    @Published private(set) var currentCharacterIndex = 0
    @Published private(set) var playbackID = UUID()

    let characters: [JapaneseCharacter]

    init(
        characters: [JapaneseCharacter]
    ) {
        self.characters = characters
    }

    var currentCharacter: JapaneseCharacter? {
        guard characters.indices.contains(
            currentCharacterIndex
        ) else {
            return nil
        }

        return characters[currentCharacterIndex]
    }

    var isLastCharacter: Bool {
        currentCharacterIndex ==
            characters.count - 1
    }

    func advance() {
        guard !isLastCharacter else {
            return
        }

        currentCharacterIndex += 1
    }

    func replay() {
        currentCharacterIndex = 0
        playbackID = UUID()
    }
}
