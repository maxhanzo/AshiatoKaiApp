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
                            .font(AshiatoKaiTheme.Typography.recordTitle)
                            .foregroundStyle(AshiatoKaiTheme.Colour.sumi)

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
                                .font(AshiatoKaiTheme.Typography.caption)
                                .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi.opacity(0.65))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("results.title")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .top) {
            HStack {
                Text(resultCountText)
                    .font(AshiatoKaiTheme.Typography.metadata)
                    .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(AshiatoKaiTheme.Colour.paper.opacity(0.96))
        }
        .ashiatoArchiveStyle()
    }

    private var resultCountText: String {
        if records.count == 1 {
            return String(localized: "results.count.one")
        }

        return String(
            format: String(localized: "results.count.many"),
            records.count
        )
    }
}
