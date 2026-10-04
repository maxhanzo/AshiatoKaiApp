//
//  NameSurnameKanjiView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import SwiftUI

struct NameSurnameKanjiView: View {
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
                        Text("Como se escreve:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(romajiName)
                            .font(.title3)
                    }

                    if let japaneseName =
                            member.japaneseFullName {
                        VStack(
                            alignment: .leading,
                            spacing: 4
                        ) {
                            Text("Em japonês:")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text(japaneseName)
                                .font(.title2)
                        }
                    }
                }
                .padding(.vertical, 4)
            }

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
                        )
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )
                    .padding(.vertical, 24)
                }
            }
        }
        .navigationTitle(member.fullName)
        .navigationBarTitleDisplayMode(.inline)
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
            ) { _, character in
                Text(String(character))
                    .font(.system(size: 52))
            }
        }
    }
}
