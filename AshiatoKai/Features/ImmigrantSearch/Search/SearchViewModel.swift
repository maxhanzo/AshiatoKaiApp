//
//  SearchViewModel.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import Foundation
import Combine

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

    private let retrieveImmigrantsUseCase: any RetrieveImmigrantsUseCaseInterface

    private let actions = PassthroughSubject<Action, Never>()
    private let navigationSubject = PassthroughSubject<SearchNavigationEvent, Never>()
    private var cancellables = Set<AnyCancellable>()

    var navigation: AnyPublisher<SearchNavigationEvent, Never> {
        navigationSubject.eraseToAnyPublisher()
    }

    init(
        retrieveImmigrantsUseCase: any RetrieveImmigrantsUseCaseInterface
    ) {
        self.retrieveImmigrantsUseCase = retrieveImmigrantsUseCase

        $form
            .map(\.validationMessage)
            .removeDuplicates()
            .sink { [weak self] message in
                self?.validationMessage = message
            }
            .store(in: &cancellables)

        // The search button remains available during loading: a new submission
        // supersedes the previous request. Cancel is also an inner publisher.
        $form
            .map { $0.validationMessage == nil }
            .removeDuplicates()
            .sink { [weak self] value in
                self?.canSearch = value
            }
            .store(in: &cancellables)

        actions
            .map { [retrieveImmigrantsUseCase] action -> AnyPublisher<SearchState, Never> in
                switch action {
                case .cancel:
                    return Just(SearchState.idle)
                        .eraseToAnyPublisher()

                case .search(let criteria):
                    return retrieveImmigrantsUseCase
                        .execute(criteria: criteria)
                        .map(SearchState.results)
                        // Catch inside the inner publisher: subsequent searches
                        // must still work after a failed request.
                        .catch {
                            Just(SearchState.failed($0.localizedDescription))
                        }
                        .prepend(SearchState.loading)
                        // Schedule before switchToLatest so queued responses from
                        // cancelled requests cannot leak into the UI afterwards.
                        .receive(on: DispatchQueue.main)
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .sink { [weak self] state in
                guard let self else { return }

                self.state = state

                if case .results(let records) = state {
                    self.navigationSubject.send(
                        .showResults(records)
                    )
                }
            }
            .store(in: &cancellables)
    }

    func search() {
        guard form.validationMessage == nil else { return }
        actions.send(.search(form.criteria))
    }

    func cancel() {
        actions.send(.cancel)
    }

    func clear() {
        actions.send(.cancel)
        form = SearchForm()
    }

    func select(_ record: SearchRecord) {
        navigationSubject.send(.showDetail(record))
    }
}
