//
//  GroupDetailsView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import SwiftUI

struct GroupDetailsView: View {
    @StateObject var viewModel: GroupDetailsViewModel
    
    let onMemberSelected: (ImmigrantGroupMember) -> Void

    var body: some View {
        content
            .navigationTitle("group.title")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.retrieveGroup()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("group.loading")

        case .loaded(let group):
            Form {
                Section("record.journey") {
                    LabeledContent(
                        "group.id",
                        value: String(group.groupID)
                    )
                }

                Section("group.members") {
                    ForEach(group.immigrants) { immigrant in
                        Button {
                            onMemberSelected(immigrant)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(immigrant.fullName)
                                        .foregroundStyle(.primary)

                                    if let japaneseName = immigrant.japaneseFullName {
                                        Text(japaneseName)
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.footnote)
                                    .foregroundStyle(.tertiary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

        case .failed(let message):
            ContentUnavailableView(
                "group.error.title",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }}
