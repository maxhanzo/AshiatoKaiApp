//
//  RecordDetailView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import SwiftUI

// Read-only presentation needs no artificial ViewModel. Introduce one when
// detail loading, actions or derived business state are required.
struct RecordDetailView: View {
    let record: SearchRecord

    var body: some View {
        Form {
            Section("Record") {
                LabeledContent("Name", value: record.name)
                LabeledContent("Surname", value: record.surname)
                LabeledContent("Year", value: String(record.year))
                LabeledContent("Prefecture", value: record.prefecture)
                LabeledContent("Ship name", value: record.shipName)
            }
            Section {
                Text("This is a fictional sample record.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(record.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
