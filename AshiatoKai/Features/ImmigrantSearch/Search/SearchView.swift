//
//  SearchView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 01/10/26.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    @FocusState private var focusedField: Field?
    private enum Field: Hashable { case name, surname, year, prefecture, ship }

    var body: some View {
        Form {
            Section {
                TextField("search.name.placeholder", text: $viewModel.form.name)
                    .focused($focusedField, equals: .name)
                    .textContentType(.givenName)
                    .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
                TextField("search.surname.placeholder", text: $viewModel.form.surname)
                    .focused($focusedField, equals: .surname)
                    .textContentType(.familyName)
                    .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
                TextField("search.year.placeholder", text: $viewModel.form.year)
                    .focused($focusedField, equals: .year)
                    .keyboardType(.numberPad)
                    .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
                TextField("search.prefecture.placeholder", text: $viewModel.form.prefecture)
                    .focused($focusedField, equals: .prefecture)
                    .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
                TextField("search.ship.placeholder", text: $viewModel.form.shipName)
                    .focused($focusedField, equals: .ship)
                    .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
            } header: {
                Text("search.criteria")
                    .font(.custom("AvenirNext-DemiBold", size: 15, relativeTo: .subheadline))
            } footer: {
                Text("search.footer")
                    .font(.custom("AvenirNext-Regular", size: 13, relativeTo: .footnote))
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            if let message = viewModel.validationMessage {
                Section {
                    Label(message, systemImage: "exclamationmark.circle")
                        .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
                        .foregroundStyle(.red)
                }
                .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
            }
            

            Section {
                Button {
                    focusedField = nil
                    viewModel.search()
                } label: {
                    Label("search.button", systemImage: "magnifyingglass")
                        .font(.custom("AvenirNext-Medium", size: 17, relativeTo: .body))
                }
                .disabled(!viewModel.canSearch)

                Button("search.clear") { viewModel.clear() }
                    .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
            
            Section {
                Button {
                    focusedField = nil
                    viewModel.contactUs()
                } label: {
                    Label("contact.title", systemImage: "envelope")
                        .font(.custom("AvenirNext-Medium", size: 17, relativeTo: .body))
                }
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            switch viewModel.state {
            case .loading:
                Section {
                    HStack {
                        ProgressView()
                        Text("search.searching")
                            .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
                    }

                    Button(
                        "search.cancel",
                        role: .cancel
                    ) {
                        viewModel.cancel()
                    }
                    .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
                }
                .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            case .failed(let message):
                Section {
                    Text(message)
                        .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
                        .foregroundStyle(.red)

                    Button("search.try_again") {
                        focusedField = nil
                        viewModel.search()
                    }
                    .disabled(!viewModel.canSearch)
                    .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
                }
                .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            case .idle,
                 .empty,
                 .results:
                EmptyView()
            }

        }
        .navigationTitle("search.title")
        .navigationBarTitleDisplayMode(.large)
        .scrollDismissesKeyboard(.interactively)
        .ashiatoArchiveStyle()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("common.done") { focusedField = nil }
                    .font(.custom("AvenirNext-Medium", size: 15, relativeTo: .body))
            }
        }
    }
}
