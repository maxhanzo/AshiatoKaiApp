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
                .font(AshiatoKaiTheme.Typography.body)

                Button("search.button") {
                    viewModel.search()
                }
                .font(AshiatoKaiTheme.Typography.body)
                .disabled(!viewModel.canSearch)
            } header: {
                Text("search.button")
            } footer: {
                Text(
                    "statistics.surnames.search.help"
                )
                .font(AshiatoKaiTheme.Typography.caption)
                .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            results
        }
        .navigationTitle("statistics.surnames.search")
        .navigationBarTitleDisplayMode(.inline)
        .ashiatoArchiveStyle()
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
                        .tint(AshiatoKaiTheme.Colour.vermilion)
                    Spacer()
                }
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

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
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

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
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

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
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
        }
    }

    private func statisticRow(
        _ statistic: SurnameStatistics
    ) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(statistic.surnameRomaji)
                    .font(AshiatoKaiTheme.Typography.recordTitle)
                    .foregroundStyle(AshiatoKaiTheme.Colour.sumi)

                LabeledContent("statistics.immigrants") {
                    Text(statistic.count.formatted())
                        .font(AshiatoKaiTheme.Typography.metadata)
                        .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                }

                LabeledContent("statistics.rank") {
                    Text("#\(statistic.rank)")
                        .font(AshiatoKaiTheme.Typography.metadata)
                        .monospacedDigit()
                        .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)
                }
            }

            Spacer()

            if !statistic.surnameKanji.isEmpty {
                Text(statistic.surnameKanji)
                    .font(.system(size: 34, weight: .regular, design: .serif))
                    .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(
                    AshiatoKaiTheme.Colour.mutedSumi.opacity(0.65)
                )
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}
