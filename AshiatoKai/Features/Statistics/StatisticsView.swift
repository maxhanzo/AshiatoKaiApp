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
                        systemImage: "map",
                        accent: AshiatoKaiTheme.Colour.indigo
                    )
                }

                Button {
                    viewModel.showPrefectureSearch()
                } label: {
                    row(
                        title: "statistics.prefectures.search",
                        subtitle: "statistics.prefectures.search.subtitle",
                        systemImage: "magnifyingglass",
                        accent: AshiatoKaiTheme.Colour.indigo
                    )
                }
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            Section("statistics.surnames.section") {
                Button {
                    viewModel.showTopSurnames()
                } label: {
                    row(
                        title: "statistics.surnames.top10",
                        subtitle: "statistics.surnames.top10.subtitle",
                        systemImage: "person.2",
                        accent: AshiatoKaiTheme.Colour.vermilion
                    )
                }

                Button {
                    viewModel.showSurnameSearch()
                } label: {
                    row(
                        title: "statistics.surnames.search",
                        subtitle: "statistics.surnames.search.subtitle",
                        systemImage: "character.book.closed",
                        accent: AshiatoKaiTheme.Colour.vermilion
                    )
                }
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            Section("statistics.names.section") {
                Button {
                    viewModel.showTopNames()
                } label: {
                    row(
                        title: "statistics.names.top10",
                        subtitle: "statistics.names.top10.subtitle",
                        systemImage: "person.text.rectangle",
                        accent: AshiatoKaiTheme.Colour.vermilion
                    )
                }

                Button {
                    viewModel.showNameSearch()
                } label: {
                    row(
                        title: "statistics.names.search",
                        subtitle: "statistics.names.search.subtitle",
                        systemImage: "character.book.closed",
                        accent: AshiatoKaiTheme.Colour.vermilion
                    )
                }
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
        }
        .navigationTitle("statistics.title")
        .navigationBarTitleDisplayMode(.large)
        .ashiatoArchiveStyle()
    }

    private func row(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        systemImage: String,
        accent: Color
    ) -> some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(accent)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AshiatoKaiTheme.Typography.body)
                    .foregroundStyle(AshiatoKaiTheme.Colour.sumi)

                Text(subtitle)
                    .font(AshiatoKaiTheme.Typography.caption)
                    .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(
                    AshiatoKaiTheme.Colour.mutedSumi.opacity(0.65)
                )
        }
        .contentShape(Rectangle())
    }
}
