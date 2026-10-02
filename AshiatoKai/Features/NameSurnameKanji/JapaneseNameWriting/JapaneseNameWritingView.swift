//
//  JapaneseNameWritingView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import SwiftUI

struct JapaneseNameWritingView: View {

    @StateObject private var viewModel:
        JapaneseNameWritingViewModel

    private let characterPause:
        Duration = .milliseconds(350)

    init(
        characters: [JapaneseCharacter]
    ) {
        _viewModel = StateObject(
            wrappedValue:
                JapaneseNameWritingViewModel(
                    characters: characters
                )
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            if let character =
                viewModel.currentCharacter {

                JapaneseCharacterWritingView(
                    character: character
                ) {
                    characterCompleted()
                }
                .id(
                    "\(viewModel.playbackID)-\(viewModel.currentCharacterIndex)"
                )
                .frame(
                    width: 220,
                    height: 220
                )

                Text(characterProgressText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Button {
                viewModel.replay()
            } label: {
                Label(
                    "Replay",
                    systemImage:
                        "arrow.counterclockwise"
                )
            }
            .buttonStyle(.bordered)
        }
    }

    private var characterProgressText: String {
        guard !viewModel.characters.isEmpty else {
            return ""
        }

        return
            "\(viewModel.currentCharacterIndex + 1) / \(viewModel.characters.count)"
    }

    private func characterCompleted() {
        guard !viewModel.isLastCharacter else {
            return
        }

        Task { @MainActor in
            try? await Task.sleep(
                for: characterPause
            )

            guard !Task.isCancelled else {
                return
            }

            viewModel.advance()
        }
    }
}
