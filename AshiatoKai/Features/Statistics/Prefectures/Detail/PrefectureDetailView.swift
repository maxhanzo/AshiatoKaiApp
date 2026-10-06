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
            .background(AshiatoKaiTheme.Colour.paper)
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
                .tint(AshiatoKaiTheme.Colour.indigo)
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
                        .font(AshiatoKaiTheme.Typography.screenTitle)
                        .foregroundStyle(AshiatoKaiTheme.Colour.indigo)

                    if let japaneseName =
                        geolocation.nameJapanese,
                       !japaneseName.isEmpty {

                        HStack {
                            Text(japaneseName)
                                .font(AshiatoKaiTheme.Typography.japaneseName)
                                .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                                .textSelection(.enabled)

                            Spacer()

                            Button {
                                UIPasteboard.general.string = japaneseName
                            } label: {
                                Image(systemName: "doc.on.doc")
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(AshiatoKaiTheme.Colour.indigo)
                            .accessibilityLabel("kanji.copy_japanese_name.accessibility")
                        }
                    }
                }

                GeographicShapeView(
                    geolocation: geolocation
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    AshiatoKaiTheme.Colour.lightPaper,
                    in: RoundedRectangle(
                        cornerRadius: AshiatoKaiTheme.Layout.cornerRadius,
                        style: .continuous
                    )
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: AshiatoKaiTheme.Layout.cornerRadius,
                        style: .continuous
                    )
                    .stroke(
                        AshiatoKaiTheme.Colour.indigo.opacity(0.18),
                        lineWidth: 1
                    )
                }

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
                .font(AshiatoKaiTheme.Typography.metadata)
                .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)

            Text(capital.name)
                .font(AshiatoKaiTheme.Typography.sectionTitle)
                .foregroundStyle(AshiatoKaiTheme.Colour.indigo)

            if let japaneseName =
                capital.nameJapanese,
               !japaneseName.isEmpty {

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text("kanji.in_japanese")
                        .font(AshiatoKaiTheme.Typography.metadata)
                        .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)

                    HStack {
                        Text(japaneseName)
                            .font(AshiatoKaiTheme.Typography.japaneseName)
                            .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                            .textSelection(.enabled)

                        Spacer()

                        Button {
                            UIPasteboard.general.string = japaneseName
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(AshiatoKaiTheme.Colour.indigo)
                        .accessibilityLabel("kanji.copy_japanese_name.accessibility")
                    }
                }
            }

            if let modernName =
                capital.modernName,
               !modernName.isEmpty,
               modernName != capital.name {

                Text("statistics.modern_name \(modernName)")
                    .font(AshiatoKaiTheme.Typography.metadata)
                    .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)
            }
        }
    }
}
