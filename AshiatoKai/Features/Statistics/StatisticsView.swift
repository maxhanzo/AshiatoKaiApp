//
//  StatisticsView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import SwiftUI
import Combine

struct StatisticsView: View {

    @ObservedObject var viewModel: StatisticsViewModel

    var body: some View {
        List {
            Section("Prefectures") {
                Button {
                    viewModel.showTopPrefectures()
                } label: {
                    row(
                        title: "Top 10 Prefectures",
                        subtitle: "Prefectures with the most immigrants",
                        systemImage: "map"
                    )
                }

                Button {
                    viewModel.showPrefectureSearch()
                } label: {
                    row(
                        title: "Prefecture Search",
                        subtitle: "Find the number and ranking of a prefecture",
                        systemImage: "magnifyingglass"
                    )
                }
            }

            Section("Surnames") {
                Button {
                    viewModel.showTopSurnames()
                } label: {
                    row(
                        title: "Top 10 Surnames",
                        subtitle: "Most common surnames in the records",
                        systemImage: "person.2"
                    )
                }

                Button {
                    viewModel.showSurnameSearch()
                } label: {
                    row(
                        title: "Surname Search",
                        subtitle: "Find variants, counts and rankings",
                        systemImage: "character.book.closed"
                    )
                }
            }
        }
        .navigationTitle("Statistics")
    }

    private func row(
        title: String,
        subtitle: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .contentShape(Rectangle())
    }
}
