//
//  TopNamesView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI

struct TopNamesView: View {

    @StateObject private var viewModel: TopNamesViewModel

    let onNameSelected:
        (NameStatistics) -> Void

    init(
        viewModel: TopNamesViewModel,
        onNameSelected:
            @escaping (NameStatistics) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )

        self.onNameSelected =
            onNameSelected
    }

    var body: some View {
        content
            .navigationTitle("statistics.names.top10")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if case .idle = viewModel.state {
                    viewModel.load()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )

        case .loaded(let statistics):
            List(statistics) { statistic in
                Button {
                    onNameSelected(statistic)
                } label: {
                    nameRow(statistic)
                }
                .buttonStyle(.plain)
            }

        case .empty:
            ContentUnavailableView(
                "statistics.no_statistics",
                systemImage: "person.2",
                description: Text(
                    "statistics.names.none_available"
                )
            )

        case .failed(let message):
            ContentUnavailableView {
                Label(
                    "statistics.load_failed",
                    systemImage: "exclamationmark.triangle"
                )
            } description: {
                Text(message)
            } actions: {
                Button("common.try_again") {
                    viewModel.load()
                }
            }
        }
    }

    private func nameRow(
        _ statistic: NameStatistics
    ) -> some View {
        HStack(spacing: 16) {
            Text("\(statistic.rank)")
                .font(.headline)
                .monospacedDigit()
                .frame(width: 32)

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(statistic.nameRomaji)
                    .font(.headline)

                Text(
                    "\(statistic.count.formatted()) \(String(localized: "statistics.immigrants.lowercase"))"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Spacer()

            if !statistic.nameKanji.isEmpty {
                Text(statistic.nameKanji)
                    .font(.title2)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
