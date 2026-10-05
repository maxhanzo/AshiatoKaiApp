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

                Button("search.button") {
                    viewModel.search()
                }
                .disabled(!viewModel.canSearch)
            } header: {
                Text("search.button")
            } footer: {
                Text(
                    "statistics.prefectures.search.help"
                )
            }

            results
        }
        .navigationTitle("statistics.prefectures.search")
        .navigationBarTitleDisplayMode(.inline)
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
                    Spacer()
                }
            }

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
        }
    }

    private func statisticRow(
        _ statistic: PrefectureStatistics
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(statistic.prefectureName)
                    .font(.headline)

                Spacer()

                Text("#\(statistic.rank)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }

            LabeledContent(
                "statistics.immigrants",
                value: statistic.count.formatted()
            )
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
