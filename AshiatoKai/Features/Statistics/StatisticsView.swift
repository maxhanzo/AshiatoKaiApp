//
//  StatisticsView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI
import Combine

struct StatisticsView: View {

    @ObservedObject var viewModel: StatisticsViewModel

    var body: some View {
        List {
            Section("statistics.prefectures.section") {
                Button {
                    viewModel.showTopPrefectures()
                } label: {
                    row(
                        title: "statistics.prefectures.top10",
                        subtitle: "statistics.prefectures.top10.subtitle",
                        systemImage: "map"
                    )
                }

                Button {
                    viewModel.showPrefectureSearch()
                } label: {
                    row(
                        title: "statistics.prefectures.search",
                        subtitle: "statistics.prefectures.search.subtitle",
                        systemImage: "magnifyingglass"
                    )
                }
            }

            Section("statistics.surnames.section") {
                Button {
                    viewModel.showTopSurnames()
                } label: {
                    row(
                        title: "statistics.surnames.top10",
                        subtitle: "statistics.surnames.top10.subtitle",
                        systemImage: "person.2"
                    )
                }

                Button {
                    viewModel.showSurnameSearch()
                } label: {
                    row(
                        title: "statistics.surnames.search",
                        subtitle: "statistics.surnames.search.subtitle",
                        systemImage: "character.book.closed"
                    )
                }
            }
        }
        .navigationTitle("statistics.title")
    }

    private func row(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
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
