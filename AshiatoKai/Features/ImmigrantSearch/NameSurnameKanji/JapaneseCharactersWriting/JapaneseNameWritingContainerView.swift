//
//  JapaneseNameWritingContainerView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import SwiftUI

struct JapaneseNameWritingContainerView: View {

    let name: String

    @State private var characters:
        [JapaneseCharacter] = []

    @State private var errorMessage:
        String?

    var body: some View {
        Group {
            if !characters.isEmpty {
                JapaneseNameWritingView(
                    characters: characters
                )
            } else if let errorMessage {
                ContentUnavailableView(
                    "Name unavailable",
                    systemImage:
                        "character.book.closed",
                    description:
                        Text(errorMessage)
                )
            } else {
                ProgressView()
            }
        }
        .task(id: name) {
            loadName()
        }
    }

    private func loadName() {
        do {
            let loader =
                JapaneseCharacterLoader()

            characters = try name
                .filter { !$0.isWhitespace }
                .map {
                    try loader.load(
                        character: $0
                    )
                }

            errorMessage = nil
        } catch {
            characters = []
            errorMessage =
                error.localizedDescription
        }
    }
}
