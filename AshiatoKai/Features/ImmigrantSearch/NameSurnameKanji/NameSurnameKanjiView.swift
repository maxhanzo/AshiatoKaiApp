//
//  NameSurnameKanjiView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import SwiftUI

struct NameSurnameKanjiView: View {
    @State private var highlightedCharacterIndex = 0
    
    let member: ImmigrantGroupMember

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

                        Text(romajiName)
                            .font(AshiatoKaiTheme.Typography.sectionTitle)
                            .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                    }

                    if let japaneseName =
                            member.japaneseFullName {
                        VStack(
                            alignment: .leading,
                            spacing: 4
                        ) {
                            Text("kanji.in_japanese")
                                .font(AshiatoKaiTheme.Typography.metadata)
                                .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)

                            HStack {
                                Text(japaneseName)
                                    .font(AshiatoKaiTheme.Typography.japaneseName)
                                    .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                                    .textSelection(.enabled)

                                Spacer()

                                Button {
                                    UIPasteboard.general.string = japaneseName
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)
                                .accessibilityLabel("kanji.copy_name.accessibility")
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            if let japaneseName =
                member.japaneseFullName {

                Section {
                    HStack(
                        alignment: .top,
                        spacing: 40
                    ) {
                        verticalName(japaneseName)

                        JapaneseNameWritingContainerView(
                            name: japaneseName
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
        }
        .navigationTitle(member.fullName)
        .navigationBarTitleDisplayMode(.inline)
        .ashiatoArchiveStyle()
    }

    private var romajiName: String {
        [
            member.surnameRomaji,
            member.nameRomaji
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }
        .joined(separator: " ")
        .capitalized
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
                    // A serif Japanese system design gives the static vertical
                    // name a Mincho / calligraphic character without bundling
                    // a decorative font or altering the stroke engine.
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
