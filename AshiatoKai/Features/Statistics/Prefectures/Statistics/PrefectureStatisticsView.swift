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
                    "Prefecture",
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

                Button("Search") {
                    viewModel.search()
                }
                .disabled(!viewModel.canSearch)
            } header: {
                Text("Search")
            } footer: {
                Text(
                    "Enter a Japanese prefecture, for example Yamaguchi or Hiroshima."
                )
            }

            results
        }
        .navigationTitle("Prefecture Search")
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
            Section("Results") {
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
                    "No Results",
                    systemImage: "magnifyingglass",
                    description: Text(
                        "No statistics were found for this prefecture."
                    )
                )
            }

        case .failed(let message):
            Section {
                ContentUnavailableView {
                    Label(
                        "Unable to Search",
                        systemImage: "exclamationmark.triangle"
                    )
                } description: {
                    Text(message)
                } actions: {
                    Button("Try Again") {
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
                "Immigrants",
                value: statistic.count.formatted()
            )
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
