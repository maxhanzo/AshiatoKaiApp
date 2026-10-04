//
//  SurnameStatisticsView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
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
                    "Surname",
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

                Button("Search") {
                    viewModel.search()
                }
                .disabled(!viewModel.canSearch)
            } header: {
                Text("Search")
            } footer: {
                Text(
                    "Enter a surname in Romaji, for example Ueda, Sato or Tanaka."
                )
            }

            results
        }
        .navigationTitle("Surname Search")
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
                    "No Results",
                    systemImage: "magnifyingglass",
                    description: Text(
                        "No statistics were found for this surname."
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
        _ statistic: SurnameStatistics
    ) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(statistic.surnameRomaji)
                    .font(.headline)

                LabeledContent(
                    "Immigrants",
                    value: statistic.count.formatted()
                )

                LabeledContent(
                    "Rank",
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
