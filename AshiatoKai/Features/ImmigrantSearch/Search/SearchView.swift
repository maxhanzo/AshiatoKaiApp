//
//  SearchView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    @FocusState private var focusedField: Field?
    private enum Field: Hashable { case name, surname, year, prefecture, ship }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $viewModel.form.name)
                    .focused($focusedField, equals: .name)
                    .textContentType(.givenName)
                TextField("Surname", text: $viewModel.form.surname)
                    .focused($focusedField, equals: .surname)
                    .textContentType(.familyName)
                TextField("Year", text: $viewModel.form.year)
                    .focused($focusedField, equals: .year)
                    .keyboardType(.numberPad)
                TextField("Prefecture", text: $viewModel.form.prefecture)
                    .focused($focusedField, equals: .prefecture)
                TextField("Ship name", text: $viewModel.form.shipName)
                    .focused($focusedField, equals: .ship)
            } header: {
                Text("Search criteria")
            } footer: {
                Text("Enter a name or surname. Add optional filters to narrow your search.")
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
                    Label("Search", systemImage: "magnifyingglass")
                }
                .disabled(!viewModel.canSearch)

                Button("Clear form") { viewModel.clear() }
            }

            switch viewModel.state {
            case .loading:
                Section {
                    HStack {
                        ProgressView()
                        Text("Searching…")
                    }

                    Button(
                        "Cancel search",
                        role: .cancel
                    ) {
                        viewModel.cancel()
                    }
                }

            case .failed(let message):
                Section {
                    Text(message)
                        .foregroundStyle(.red)

                    Button("Try again") {
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
        .navigationTitle("Search")
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
    }
}
