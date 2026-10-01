//
//  SearchViewModel.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import Foundation
import Combine

struct SearchForm: Equatable {
    var name = ""
    var surname = ""
    var year = ""
    var prefecture = ""
    var shipName = ""

    var validationMessage: String? {
        let text = year.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return nil }
        guard text.allSatisfy({ $0.isASCII && $0.isNumber }),
              let value = Int(text), (1...9999).contains(value) else {
            return "Enter a year between 1 and 9999, or leave it blank."
        }
        return nil
    }

    var criteria: SearchCriteria {
        func trim(_ value: String) -> String {
            value.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return SearchCriteria(name: trim(name), surname: trim(surname),
                              year: Int(trim(year)), prefecture: trim(prefecture),
                              shipName: trim(shipName))
    }
}

enum SearchState {
    case idle
    case loading
    case results([SearchRecord])
    case empty
    case failed(String)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

enum SearchNavigationEvent {
    case showDetail(SearchRecord)
}

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var form = SearchForm()
    @Published private(set) var state: SearchState = .idle
    @Published private(set) var canSearch = true
    @Published private(set) var validationMessage: String?

    private enum Action {
        case search(SearchCriteria)
        case cancel
    }

    private let actions = PassthroughSubject<Action, Never>()
    private let navigationSubject = PassthroughSubject<SearchNavigationEvent, Never>()
    private var cancellables = Set<AnyCancellable>()

    var navigation: AnyPublisher<SearchNavigationEvent, Never> {
        navigationSubject.eraseToAnyPublisher()
    }

    init(repository: any SearchRepository) {
        $form.map(\.validationMessage)
            .removeDuplicates()
            .sink { [weak self] message in self?.validationMessage = message }
            .store(in: &cancellables)

        // The search button remains available during loading: a new submission
        // supersedes the previous request. Cancel is also an inner publisher.
        $form.map { $0.validationMessage == nil }
            .removeDuplicates()
            .sink { [weak self] value in self?.canSearch = value }
            .store(in: &cancellables)

        actions
            .map { action -> AnyPublisher<SearchState, Never> in
                switch action {
                case .cancel:
                    return Just(SearchState.idle).eraseToAnyPublisher()
                case .search(let criteria):
                    return repository.search(criteria: criteria)
                        .map { records -> SearchState in
                            records.isEmpty ? .empty : .results(records)
                        }
                        // Catch inside the inner publisher: subsequent searches
                        // must still work after a failed request.
                        .catch { Just(SearchState.failed($0.localizedDescription)) }
                        .prepend(SearchState.loading)
                        // Schedule before switchToLatest so queued responses from
                        // cancelled requests cannot leak into the UI afterwards.
                        .receive(on: DispatchQueue.main)
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .sink { [weak self] state in self?.state = state }
            .store(in: &cancellables)
    }

    func search() {
        guard form.validationMessage == nil else { return }
        actions.send(.search(form.criteria))
    }

    func cancel() { actions.send(.cancel) }

    func clear() {
        actions.send(.cancel)
        form = SearchForm()
    }

    func select(_ record: SearchRecord) {
        navigationSubject.send(.showDetail(record))
    }
}
