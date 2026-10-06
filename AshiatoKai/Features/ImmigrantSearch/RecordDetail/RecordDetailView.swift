//
//  RecordDetailView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 01/10/26.
//

import SwiftUI

struct RecordDetailView: View {
    let record: SearchRecord
    let onGroupDetails: () -> Void

    var body: some View {
        Form {
            Section("record.person") {
                LabeledContent("record.name") {
                    Text(record.name)
                        .font(AshiatoKaiTheme.Typography.recordTitle)
                        .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                }

                LabeledContent("record.surname") {
                    Text(record.surname)
                        .font(AshiatoKaiTheme.Typography.recordTitle)
                        .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                }

                if let japaneseFullName = record.japaneseFullName {
                    LabeledContent("record.japanese_name") {
                        Text(japaneseFullName)
                            .font(AshiatoKaiTheme.Typography.japaneseName) // Type 'AshiatoKaiTheme.Typography' has no member 'japaneseName'
                            .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)
                    }
                }
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            Section("record.journey") {
                optionalContent("record.year", record.year.map(String.init))
                optionalContent("record.prefecture", record.prefecture)
                optionalContent("record.ship_name", record.shipName)
                optionalContent("record.departure_date", record.departureDate)
                optionalContent("record.arrival_date", record.arrivalDate)
                optionalContent("record.destination", record.destination)
                optionalContent("record.farm", record.farm)
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            Section {
                Button {
                    onGroupDetails()
                } label: {
                    Label("record.group_details", systemImage: "person.3")
                        .font(AshiatoKaiTheme.Typography.body)
                }
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
        }
        .navigationTitle(record.fullName)
        .navigationBarTitleDisplayMode(.inline)
        .ashiatoArchiveStyle()
    }

    @ViewBuilder
    private func optionalContent(
        _ label: LocalizedStringKey,
        _ value: String?
    ) -> some View {
        if let value, !value.isEmpty {
            LabeledContent(label) {
                Text(value)
                    .font(AshiatoKaiTheme.Typography.metadata)
                    .foregroundStyle(
                        label == "record.prefecture"
                            ? AshiatoKaiTheme.Colour.indigo
                            : AshiatoKaiTheme.Colour.sumi
                    )
            }
        }
    }
}
