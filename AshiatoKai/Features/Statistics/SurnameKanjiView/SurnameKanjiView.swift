//
//  SurnameKanjiView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import SwiftUI

struct SurnameKanjiView: View {

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
                        Text("Como se escreve:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(
                            statistic.surnameRomaji.capitalized
                        )
                        .font(.title3)
                    }

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        Text("Em japonês:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(statistic.surnameKanji)
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
                    verticalSurname(
                        statistic.surnameKanji
                    )

                    JapaneseNameWritingContainerView(
                        name: statistic.surnameKanji
                    )
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .center
                )
                .padding(.vertical, 24)
            }
        }
        .navigationTitle(
            statistic.surnameRomaji.uppercased()
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    private func verticalSurname(
        _ surname: String
    ) -> some View {
        VStack(spacing: 8) {
            ForEach(
                Array(surname.enumerated()),
                id: \.offset
            ) { _, character in
                Text(String(character))
                    .font(.system(size: 52))
            }
        }
    }
}
