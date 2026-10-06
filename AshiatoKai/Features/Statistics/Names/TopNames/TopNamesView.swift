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
            .background(AshiatoKaiTheme.Colour.paper)
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
                .tint(AshiatoKaiTheme.Colour.vermilion)
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
                .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
            }
            .ashiatoArchiveStyle()

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
                .font(AshiatoKaiTheme.Typography.sectionTitle)
                .monospacedDigit()
                .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)
                .frame(width: 32)

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(statistic.nameRomaji)
                    .font(AshiatoKaiTheme.Typography.recordTitle)
                    .foregroundStyle(AshiatoKaiTheme.Colour.sumi)

                Text(
                    "\(statistic.count.formatted()) \(String(localized: "statistics.immigrants.lowercase"))"
                )
                .font(AshiatoKaiTheme.Typography.metadata)
                .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)
            }

            Spacer()

            if !statistic.nameKanji.isEmpty {
                Text(statistic.nameKanji)
                    .font(.system(size: 28, weight: .regular, design: .serif))
                    .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(
                    AshiatoKaiTheme.Colour.mutedSumi.opacity(0.65)
                )
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
