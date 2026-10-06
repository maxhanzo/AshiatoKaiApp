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
                TextField("search.surname.placeholder", text: $viewModel.form.surname)
                    .focused($focusedField, equals: .surname)
                    .textContentType(.familyName)
                TextField("search.year.placeholder", text: $viewModel.form.year)
                    .focused($focusedField, equals: .year)
                    .keyboardType(.numberPad)
                TextField("search.prefecture.placeholder", text: $viewModel.form.prefecture)
                    .focused($focusedField, equals: .prefecture)
                TextField("search.ship.placeholder", text: $viewModel.form.shipName)
                    .focused($focusedField, equals: .ship)
            } header: {
                Text("search.criteria")
            } footer: {
                Text("search.footer")
            }

            if let message = viewModel.validationMessage {
                Section {
                    Label(message, systemImage: "exclamationmark.circle")
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button {
                    focusedField = nil
                    viewModel.search()
                } label: {
                    Label("search.button", systemImage: "magnifyingglass")
                }
                .disabled(!viewModel.canSearch)

                Button("search.clear") { viewModel.clear() }
            }
            
            Section {
                Button {
                    focusedField = nil
                    viewModel.contactUs()
                } label: {
                    Label("contact.title", systemImage: "envelope")
                }
            }

            switch viewModel.state {
            case .loading:
                Section {
                    HStack {
                        ProgressView()
                        Text("search.searching")
                    }

                    Button(
                        "search.cancel",
                        role: .cancel
                    ) {
                        viewModel.cancel()
                    }
                }

            case .failed(let message):
                Section {
                    Text(message)
                        .foregroundStyle(.red)

                    Button("search.try_again") {
                        focusedField = nil
                        viewModel.search()
                    }
                    .disabled(!viewModel.canSearch)
                }

            case .idle,
                 .empty,
                 .results:
                EmptyView()
            }

        }
        .navigationTitle("search.title")
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("common.done") { focusedField = nil }
            }
        }
    }
}
