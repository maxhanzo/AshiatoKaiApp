//
//  TopPrefecturesView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import SwiftUI

struct TopPrefecturesView: View {

    @StateObject private var viewModel: TopPrefecturesViewModel

    let onPrefectureSelected:
        (PrefectureStatistics) -> Void

    init(
        viewModel: TopPrefecturesViewModel,
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
        content
            .navigationTitle("Top 10 Prefectures")
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
                    onPrefectureSelected(statistic)
                } label: {
                    prefectureRow(statistic)
                }
                .buttonStyle(.plain)
            }

        case .empty:
            ContentUnavailableView(
                "No Statistics",
                systemImage: "chart.bar",
                description: Text(
                    "No prefecture statistics are available."
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

    private func prefectureRow(
        _ statistic: PrefectureStatistics
    ) -> some View {
        HStack(spacing: 16) {
            Text("\(statistic.rank)")
                .font(.headline)
                .monospacedDigit()
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(statistic.prefectureName)
                    .font(.headline)

                Text(
                    "\(statistic.count.formatted()) immigrants"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
