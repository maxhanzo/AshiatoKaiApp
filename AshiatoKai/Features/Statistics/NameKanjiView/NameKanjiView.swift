//
//  NameKanjiView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI

struct NameKanjiView: View {
    @State private var highlightedCharacterIndex = 0
    
    let statistic: NameStatistics

    var body: some View {
        Form {
            Section {
                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {
                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        Text("kanji.how_written")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(
                            statistic.nameRomaji.capitalized
                        )
                        .font(.title3)
                    }

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        Text("kanji.in_japanese")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack {
                            Text(statistic.nameKanji)
                                .textSelection(.enabled)

                            Spacer()

                            Button {
                                UIPasteboard.general.string = statistic.nameKanji
                            } label: {
                                Image(systemName: "doc.on.doc")
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("kanji.copy_name.accessibility")
                        }
                            .font(.title2)
                    }
                }
                .padding(.vertical, 4)
            }

            Section {
                HStack(
                    alignment: .top,
                    spacing: 40
                ) {
                    verticalName(
                        statistic.nameKanji
                    )

                    JapaneseNameWritingContainerView(
                        name: statistic.nameKanji
                    ) { index in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            highlightedCharacterIndex = index
                        }
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .center
                )
                .padding(.vertical, 24)
            }
        }
        .navigationTitle(
            statistic.nameRomaji.uppercased()
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    private func verticalName(
        _ name: String
    ) -> some View {
        VStack(spacing: 8) {
            ForEach(
                Array(name.enumerated()),
                id: \.offset
            ) { index, character in
                Text(String(character))
                    .font(.system(size: 52))
                    .foregroundStyle(
                        index <= highlightedCharacterIndex
                            ? Color.blue
                            : Color.primary
                    )
            }
        }
    }
}
