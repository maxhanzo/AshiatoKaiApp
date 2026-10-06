//
//  TopPrefecturesView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
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
            .background(AshiatoKaiTheme.Colour.paper)
            .navigationTitle("statistics.prefectures.top10")
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
                .tint(AshiatoKaiTheme.Colour.indigo)
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
                .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
            }
            .ashiatoArchiveStyle()

        case .empty:
            ContentUnavailableView(
                "statistics.no_statistics",
                systemImage: "chart.bar",
                description: Text(
                    "statistics.prefectures.none_available"
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

    private func prefectureRow(
        _ statistic: PrefectureStatistics
    ) -> some View {
        HStack(spacing: 16) {
            Text("\(statistic.rank)")
                .font(AshiatoKaiTheme.Typography.sectionTitle)
                .monospacedDigit()
                .foregroundStyle(AshiatoKaiTheme.Colour.indigo)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(statistic.prefectureName)
                    .font(AshiatoKaiTheme.Typography.recordTitle)
                    .foregroundStyle(AshiatoKaiTheme.Colour.indigo)

                Text(
                    "\(statistic.count.formatted()) \(String(localized: "statistics.immigrants.lowercase"))"
                )
                .font(AshiatoKaiTheme.Typography.metadata)
                .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(
                    AshiatoKaiTheme.Colour.mutedSumi.opacity(0.65)
                )
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
