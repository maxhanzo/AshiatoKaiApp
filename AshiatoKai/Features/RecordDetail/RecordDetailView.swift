//
//  RecordDetailView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import SwiftUI

struct RecordDetailView: View {
    let record: SearchRecord

    var body: some View {
        Form {
            Section("Person") {
                LabeledContent("Name", value: record.name)
                LabeledContent("Surname", value: record.surname)
                if let japaneseFullName = record.japaneseFullName {
                    LabeledContent("Japanese name", value: japaneseFullName)
                }
            }

            Section("Journey") {
                optionalContent("Year", record.year.map(String.init))
                optionalContent("Prefecture", record.prefecture)
                optionalContent("Ship name", record.shipName)
                optionalContent("Departure date", record.departureDate)
                optionalContent("Arrival date", record.arrivalDate)
                optionalContent("Destination", record.destination)
                optionalContent("Farm", record.farm)
            }
        }
        .navigationTitle(record.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func optionalContent(_ label: String, _ value: String?) -> some View {
        if let value, !value.isEmpty {
            LabeledContent(label, value: value)
        }
    }
}
