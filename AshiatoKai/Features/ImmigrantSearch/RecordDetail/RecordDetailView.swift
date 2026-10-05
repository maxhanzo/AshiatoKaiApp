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
                LabeledContent("record.name", value: record.name)
                LabeledContent("record.surname", value: record.surname)

                if let japaneseFullName = record.japaneseFullName {
                    LabeledContent(
                        "record.japanese_name",
                        value: japaneseFullName
                    )
                }
            }

            Section("record.journey") {
                optionalContent("record.year", record.year.map(String.init))
                optionalContent("record.prefecture", record.prefecture)
                optionalContent("record.ship_name", record.shipName)
                optionalContent("record.departure_date", record.departureDate)
                optionalContent("record.arrival_date", record.arrivalDate)
                optionalContent("record.destination", record.destination)
                optionalContent("record.farm", record.farm)
            }

            Section {
                Button("record.group_details") {
                    onGroupDetails()
                }
            }
        }
        .navigationTitle(record.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func optionalContent(
        _ label: LocalizedStringKey,
        _ value: String?
    ) -> some View {
        if let value, !value.isEmpty {
            LabeledContent(label, value: value)
        }
    }
}
