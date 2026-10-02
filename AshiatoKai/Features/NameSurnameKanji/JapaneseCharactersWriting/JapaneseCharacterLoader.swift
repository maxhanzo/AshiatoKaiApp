//
//  JapaneseCharacterLoader.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Foundation

struct JapaneseCharacterLoader {

    private let parser = AnimCJKParser()

    func load(
        character: Character
    ) throws -> JapaneseCharacter {
        guard let filename =
            JapaneseCharacterResource.filename(
                for: character
            )
        else {
            throw JapaneseCharacterLoaderError
                .invalidCharacter(character)
        }

        guard let url = findSVG(
            filename: filename
        )
        else {
            throw JapaneseCharacterLoaderError
                .resourceNotFound(filename)
        }

        let data = try Data(
            contentsOf: url
        )

        return try parser.parse(
            character: character,
            data: data
        )
    }

    private func findSVG(
        filename: String
    ) -> URL? {
        Bundle.main.url(
            forResource: filename,
            withExtension: "svg",
            subdirectory: "svgsJa"
        )
        ??
        Bundle.main.url(
            forResource: filename,
            withExtension: "svg",
            subdirectory: "svgsJaKana"
        )
        ??
        Bundle.main.url(
            forResource: filename,
            withExtension: "svg"
        )
    }
}

enum JapaneseCharacterLoaderError:
    LocalizedError {

    case invalidCharacter(Character)
    case resourceNotFound(String)

    var errorDescription: String? {
        switch self {
        case .invalidCharacter(let character):
            return
                "Unable to resolve \(character)."

        case .resourceNotFound(let filename):
            return
                "\(filename).svg was not found."
        }
    }
}
