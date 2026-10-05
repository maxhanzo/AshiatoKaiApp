//
//  SurnameStatisticsView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI

struct SurnameStatisticsView: View {

    @ObservedObject var viewModel: SurnameStatisticsViewModel
    
    let onSurnameSelected:
            (SurnameStatistics) -> Void

    var body: some View {
        Form {
            Section {
                TextField(
                    "statistics.surnames.placeholder",
                    text: $viewModel.surname
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
                    "statistics.surnames.search.help"
                )
            }

            results
        }
        .navigationTitle("statistics.surnames.search")
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
                        onSurnameSelected(statistic)
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
                        "statistics.surnames.no_results"
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
        _ statistic: SurnameStatistics
    ) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(statistic.surnameRomaji)
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

            if !statistic.surnameKanji.isEmpty {
                Text(statistic.surnameKanji)
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
