//
//  PrefectureStatisticsView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI

struct PrefectureStatisticsView: View {

    @StateObject private var viewModel: PrefectureStatisticsViewModel

    let onPrefectureSelected:
        (PrefectureStatistics) -> Void

    init(
        viewModel: PrefectureStatisticsViewModel,
        onPrefectureSelected:
            @escaping (PrefectureStatistics) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )

        self.onPrefectureSelected =
            onPrefectureSelected
    }
    
    var body: some View {
        Form {
            Section {
                TextField(
                    "statistics.prefectures.placeholder",
                    text: $viewModel.prefecture
                )
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit {
                    if viewModel.canSearch {
                        viewModel.search()
                    }
                }
                .font(AshiatoKaiTheme.Typography.body)

                Button("search.button") {
                    viewModel.search()
                }
                .font(AshiatoKaiTheme.Typography.body)
                .disabled(!viewModel.canSearch)
            } header: {
                Text("search.button")
            } footer: {
                Text(
                    "statistics.prefectures.search.help"
                )
                .font(AshiatoKaiTheme.Typography.caption)
                .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            results
        }
        .navigationTitle("statistics.prefectures.search")
        .navigationBarTitleDisplayMode(.inline)
        .ashiatoArchiveStyle()
    }

    @ViewBuilder
    private var results: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()

        case .loading:
            Section {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(AshiatoKaiTheme.Colour.indigo)
                    Spacer()
                }
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

        case .loaded(let statistics):
            Section("search.results.section") {
                ForEach(statistics) { statistic in
                    Button {
                        onPrefectureSelected(statistic)
                    } label: {
                        statisticRow(statistic)
                    }
                    .buttonStyle(.plain)
                }
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

        case .empty:
            Section {
                ContentUnavailableView(
                    "search.results.empty.title",
                    systemImage: "magnifyingglass",
                    description: Text(
                        "statistics.prefectures.no_results"
                    )
                )
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

        case .failed(let message):
            Section {
                ContentUnavailableView {
                    Label(
                        "statistics.search_failed",
                        systemImage: "exclamationmark.triangle"
                    )
                } description: {
                    Text(message)
                } actions: {
                    Button("common.try_again") {
                        viewModel.search()
                    }
                }
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
        }
    }

    private func statisticRow(
        _ statistic: PrefectureStatistics
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(statistic.prefectureName)
                    .font(AshiatoKaiTheme.Typography.recordTitle)
                    .foregroundStyle(AshiatoKaiTheme.Colour.indigo)

                Spacer()

                Text("#\(statistic.rank)")
                    .font(AshiatoKaiTheme.Typography.sectionTitle)
                    .foregroundStyle(AshiatoKaiTheme.Colour.indigo)
                    .monospacedDigit()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(
                        AshiatoKaiTheme.Colour.mutedSumi.opacity(0.65)
                    )
            }

            LabeledContent("statistics.immigrants") {
                Text(statistic.count.formatted())
                    .font(AshiatoKaiTheme.Typography.metadata)
                    .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
