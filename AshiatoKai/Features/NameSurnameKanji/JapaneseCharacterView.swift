//
//  JapaneseCharacterDebugView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import SwiftUI

struct JapaneseCharacterView: View {

    let character: Character

    @State private var japaneseCharacter: JapaneseCharacter?
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let japaneseCharacter {
                VStack(spacing: 12) {
                    JapaneseCharacterWritingView(
                        character: japaneseCharacter
                    )
                    .frame(
                        width: 220,
                        height: 220
                    )

                    Text(
                        "\(japaneseCharacter.strokes.count) strokes"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            } else if let errorMessage {
                ContentUnavailableView(
                    "Character unavailable",
                    systemImage: "character.book.closed",
                    description: Text(errorMessage)
                )
            } else {
                ProgressView()
            }
        }
        .task(id: character) {
            loadCharacter()
        }
    }

    private func loadCharacter() {
        do {
            guard let filename =
                JapaneseCharacterResource.filename(
                    for: character
                )
            else {
                errorMessage =
                    "Unable to resolve \(character)."
                return
            }

            guard let url = findSVG(
                filename: filename
            ) else {
                errorMessage =
                    "\(filename).svg was not found."
                return
            }

            let data = try Data(contentsOf: url)

            japaneseCharacter =
                try AnimCJKParser().parse(
                    character: character,
                    data: data
                )

            errorMessage = nil
        } catch {
            japaneseCharacter = nil
            errorMessage = error.localizedDescription
        }
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
