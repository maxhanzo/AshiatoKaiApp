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
                            .font(AshiatoKaiTheme.Typography.metadata)
                            .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)

                        Text(
                            statistic.nameRomaji.capitalized
                        )
                        .font(AshiatoKaiTheme.Typography.sectionTitle)
                        .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                    }

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        Text("kanji.in_japanese")
                            .font(AshiatoKaiTheme.Typography.metadata)
                            .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)

                        HStack {
                            Text(statistic.nameKanji)
                                .font(AshiatoKaiTheme.Typography.japaneseName)
                                .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                                .textSelection(.enabled)

                            Spacer()

                            Button {
                                UIPasteboard.general.string = statistic.nameKanji
                            } label: {
                                Image(systemName: "doc.on.doc")
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)
                            .accessibilityLabel("kanji.copy_name.accessibility")
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

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
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
        }
        .navigationTitle(
            statistic.nameRomaji.uppercased()
        )
        .navigationBarTitleDisplayMode(.inline)
        .ashiatoArchiveStyle()
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
                    .font(.system(size: 54, weight: .regular, design: .serif))
                    .foregroundStyle(
                        index <= highlightedCharacterIndex
                            ? AshiatoKaiTheme.Colour.vermilion
                            : AshiatoKaiTheme.Colour.sumi
                    )
            }
        }
    }
}
