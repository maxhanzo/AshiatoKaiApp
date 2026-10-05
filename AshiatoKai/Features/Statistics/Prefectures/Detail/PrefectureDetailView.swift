//
//  PrefectureDetailView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI

struct PrefectureDetailView: View {

    @StateObject private var viewModel: PrefectureDetailViewModel

    init(
        viewModel: PrefectureDetailViewModel
    ) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }

    var body: some View {
        content
            .navigationTitle(
                viewModel.statistic.prefectureName
            )
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.load()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle,
             .loading:
            ProgressView()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )

        case .loaded(let geolocation):
            loadedContent(
                geolocation
            )

        case .failed(let message):
            ContentUnavailableView {
                Label(
                    "statistics.location_failed",
                    systemImage: "map"
                )
            } description: {
                Text(message)
            }
        }
    }

    private func loadedContent(
        _ geolocation: Geolocation
    ) -> some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(geolocation.name)
                        .font(.largeTitle)
                        .fontWeight(.semibold)

                    if let japaneseName =
                        geolocation.nameJapanese,
                       !japaneseName.isEmpty {

                        HStack {
                            Text(japaneseName)
                                .textSelection(.enabled)

                            Spacer()

                            Button {
                                UIPasteboard.general.string = japaneseName
                            } label: {
                                Image(systemName: "doc.on.doc")
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("kanji.copy_japanese_name.accessibility")
                        }
                            .font(.title2)
                            .foregroundStyle(.primary)
                    }
                }

                GeographicShapeView(
                    geolocation: geolocation
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    .quaternary.opacity(0.35),
                    in: RoundedRectangle(
                        cornerRadius: 24,
                        style: .continuous
                    )
                )

                if let capital = geolocation.capital {
                    capitalSection(capital)
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding()
        }
    }

    private func capitalSection(
        _ capital: GeographicCapital
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text("statistics.capital")
                .font(.headline)

            Text(capital.name)
                .font(.title3)

            if let japaneseName =
                capital.nameJapanese,
               !japaneseName.isEmpty {

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text("kanji.in_japanese")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    HStack {
                        Text(japaneseName)
                            .textSelection(.enabled)

                        Spacer()

                        Button {
                            UIPasteboard.general.string = japaneseName
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("kanji.copy_japanese_name.accessibility")
                    }
                        .font(.title2)
                }
            }

            if let modernName =
                capital.modernName,
               !modernName.isEmpty,
               modernName != capital.name {

                Text("statistics.modern_name \(modernName)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
