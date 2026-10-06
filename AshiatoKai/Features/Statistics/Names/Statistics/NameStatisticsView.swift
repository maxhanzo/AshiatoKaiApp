//
//  NameStatisticsView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI

struct NameStatisticsView: View {

    @ObservedObject var viewModel: NameStatisticsViewModel
    
    let onNameSelected:
            (NameStatistics) -> Void

    var body: some View {
        Form {
            Section {
                TextField(
                    "statistics.names.placeholder",
                    text: $viewModel.name
                )
                .textInputAutocapitalization(.characters)
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
                    "statistics.names.search.help"
                )
            }

            results
        }
        .navigationTitle("statistics.names.search")
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
                        onNameSelected(statistic)
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
                        "statistics.names.no_results"
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
        _ statistic: NameStatistics
    ) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(statistic.nameRomaji)
                    .font(.headline)

                LabeledContent(
                    "statistics.immigrants",
                    value: statistic.count.formatted()
                )

                LabeledContent(
                    "statistics.rank",
                    value: "#\(statistic.rank)"
                )
            }

            Spacer()

            if !statistic.nameKanji.isEmpty {
                Text(statistic.nameKanji)
                    .font(.largeTitle)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}
