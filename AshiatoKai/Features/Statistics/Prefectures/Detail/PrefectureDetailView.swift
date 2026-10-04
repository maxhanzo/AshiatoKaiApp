//
//  PrefectureDetailView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
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
                    "Unable to Load Location",
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
                        .font(.title)
                        .fontWeight(.semibold)

                    if let japaneseName =
                        geolocation.nameJapanese,
                       !japaneseName.isEmpty {

                        Text(japaneseName)
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }

                if let capital = geolocation.capital {
                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {
                        Text("Capital")
                            .font(.headline)

                        Text(capital.name)
                            .font(.title3)

                        if let japaneseName =
                            capital.nameJapanese,
                           !japaneseName.isEmpty {

                            Text(japaneseName)
                                .foregroundStyle(.secondary)
                        }

                        if let modernName =
                            capital.modernName,
                           !modernName.isEmpty,
                           modernName != capital.name {

                            Text("Modern name: \(modernName)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                geographicInformation(
                    geolocation
                )
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding()
        }
    }

    private func geographicInformation(
        _ geolocation: Geolocation
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text("Geographic Data")
                .font(.headline)

            Text(
                """
                Longitude: \
                \(geolocation.bounds.minimumLongitude) – \
                \(geolocation.bounds.maximumLongitude)
                """
            )

            Text(
                """
                Latitude: \
                \(geolocation.bounds.minimumLatitude) – \
                \(geolocation.bounds.maximumLatitude)
                """
            )
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
}
