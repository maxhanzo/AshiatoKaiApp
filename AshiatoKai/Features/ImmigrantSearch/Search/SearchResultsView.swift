//
//  SearchResultsView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//


import SwiftUI

struct SearchResultsView: View {

    let records: [SearchRecord]
    let onRecordSelected: (SearchRecord) -> Void

    var body: some View {
        List(records) { record in
            Button {
                onRecordSelected(record)
            } label: {
                HStack {
                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        Text(record.fullName)
                            .foregroundStyle(.primary)

                        let details = [
                            record.year.map(String.init),
                            record.prefecture,
                            record.shipName
                        ]
                            .compactMap { $0 }
                            .filter { !$0.isEmpty }
                            .joined(separator: " · ")

                        if !details.isEmpty {
                            Text(details)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Search Results")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .top) {
            HStack {
                Text(resultCountText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.bar)
        }
    }

    private var resultCountText: String {
        records.count == 1
            ? "1 record found"
            : "\(records.count) records found"
    }
}
