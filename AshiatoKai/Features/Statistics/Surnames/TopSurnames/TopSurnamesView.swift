//
//  TopSurnamesView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI

struct TopSurnamesView: View {

    @StateObject private var viewModel: TopSurnamesViewModel

    let onSurnameSelected:
        (SurnameStatistics) -> Void

    init(
        viewModel: TopSurnamesViewModel,
        onSurnameSelected:
            @escaping (SurnameStatistics) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )

        self.onSurnameSelected =
            onSurnameSelected
    }

    var body: some View {
        content
            .navigationTitle("statistics.surnames.top10")
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
                    onSurnameSelected(statistic)
                } label: {
                    surnameRow(statistic)
                }
                .buttonStyle(.plain)
            }

        case .empty:
            ContentUnavailableView(
                "statistics.no_statistics",
                systemImage: "person.2",
                description: Text(
                    "statistics.surnames.none_available"
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

    private func surnameRow(
        _ statistic: SurnameStatistics
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
                Text(statistic.surnameRomaji)
                    .font(.headline)

                Text(
                    "\(statistic.count.formatted()) \(String(localized: "statistics.immigrants.lowercase"))"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Spacer()

            if !statistic.surnameKanji.isEmpty {
                Text(statistic.surnameKanji)
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
