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
                Text("Name and surname are required. Add optional filters to narrow your search.")
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

                if viewModel.state.isLoading {
                    Button("Cancel search", role: .cancel) { viewModel.cancel() }
                }
                Button("Clear form") { viewModel.clear() }
            }

            Section("Results") {
                switch viewModel.state {
                case .idle:
                    Text("Enter your criteria and tap Search.")
                        .foregroundStyle(.secondary)
                case .loading:
                    HStack {
                        ProgressView()
                        Text("Searching…")
                    }
                case .empty:
                    ContentUnavailableView("No results", systemImage: "magnifyingglass",
                                           description: Text("Try fewer or different search criteria."))
                case .failed(let message):
                    Text(message).foregroundStyle(.red)
                    Button("Try again") { viewModel.search() }
                        .disabled(!viewModel.canSearch)
                case .results(let records):
                    ForEach(records) { record in
                        Button { viewModel.select(record) } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(record.fullName).foregroundStyle(.primary)
                                    Text([record.year.map(String.init), record.prefecture, record.shipName]
                                        .compactMap { $0 }
                                        .filter { !$0.isEmpty }
                                        .joined(separator: " · "))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .contentShape(Rectangle())
                        }
                    }
                }
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
