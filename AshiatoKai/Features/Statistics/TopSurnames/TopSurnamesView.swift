//
//  TopSurnamesView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import SwiftUI

struct TopSurnamesView: View {

    @ObservedObject var viewModel: TopSurnamesViewModel

    var body: some View {
        content
            .navigationTitle("Top 10 Surnames")
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
                surnameRow(statistic)
            }

        case .empty:
            ContentUnavailableView(
                "No Statistics",
                systemImage: "person.2",
                description: Text(
                    "No surname statistics are available."
                )
            )

        case .failed(let message):
            ContentUnavailableView {
                Label(
                    "Unable to Load Statistics",
                    systemImage: "exclamationmark.triangle"
                )
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") {
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

            VStack(alignment: .leading, spacing: 4) {
                Text(statistic.surnameRomaji)
                    .font(.headline)

                Text(
                    "\(statistic.count.formatted()) immigrants"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Spacer()

            if !statistic.surnameKanji.isEmpty {
                Text(statistic.surnameKanji)
                    .font(.title2)
            }
        }
        .padding(.vertical, 4)
    }
}
