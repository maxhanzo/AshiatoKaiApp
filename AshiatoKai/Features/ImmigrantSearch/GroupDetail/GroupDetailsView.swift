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
            .background(AshiatoKaiTheme.Colour.paper)
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
                .font(AshiatoKaiTheme.Typography.body)
                .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)

        case .loaded(let group):
            Form {
                Section("record.journey") {
                    LabeledContent("group.id") {
                        Text(String(group.groupID))
                            .font(AshiatoKaiTheme.Typography.metadata)
                            .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                    }
                }
                .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

                Section("group.members") {
                    ForEach(group.immigrants) { immigrant in
                        Button {
                            onMemberSelected(immigrant)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(immigrant.fullName)
                                        .font(AshiatoKaiTheme.Typography.recordTitle)
                                        .foregroundStyle(AshiatoKaiTheme.Colour.sumi)

                                    if let japaneseName = immigrant.japaneseFullName {
                                        Text(japaneseName)
                                            .font(AshiatoKaiTheme.Typography.japaneseName)
                                            .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)
                                    }
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.footnote)
                                    .foregroundStyle(
                                        AshiatoKaiTheme.Colour.mutedSumi.opacity(0.65)
                                    )
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
            }
            .ashiatoArchiveStyle()

        case .failed(let message):
            ContentUnavailableView(
                "group.error.title",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }}
