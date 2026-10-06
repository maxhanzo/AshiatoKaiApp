//
//  SurnameKanjiView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI

struct SurnameKanjiView: View {
    @State private var highlightedCharacterIndex = 0
    
    let statistic: SurnameStatistics

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
                            statistic.surnameRomaji.capitalized
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
                            Text(statistic.surnameKanji)
                                .font(AshiatoKaiTheme.Typography.japaneseName)
                                .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                                .textSelection(.enabled)

                            Spacer()

                            Button {
                                UIPasteboard.general.string = statistic.surnameKanji
                            } label: {
                                Image(systemName: "doc.on.doc")
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)
                            .accessibilityLabel("kanji.copy_surname.accessibility")
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
                    verticalSurname(
                        statistic.surnameKanji
                    )

                    JapaneseNameWritingContainerView(
                        name: statistic.surnameKanji
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
            statistic.surnameRomaji.uppercased()
        )
        .navigationBarTitleDisplayMode(.inline)
        .ashiatoArchiveStyle()
    }

    private func verticalSurname(
        _ surname: String
    ) -> some View {
        VStack(spacing: 8) {
            ForEach(
                Array(surname.enumerated()),
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
