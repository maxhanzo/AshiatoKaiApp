//
//  NameStatisticsViewModel.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine
import Foundation

@MainActor
final class NameStatisticsViewModel: ObservableObject {

    @Published var name = ""
    @Published private(set) var state: NameStatisticsState = .idle

    private enum Action {
        case search(String)
    }

    private let actionSubject = PassthroughSubject<Action, Never>()

    private let retrieveNameStatisticsUseCase:
        any RetrieveNameStatisticsUseCaseInterface

    private var cancellables = Set<AnyCancellable>()

    init(
        retrieveNameStatisticsUseCase:
            any RetrieveNameStatisticsUseCaseInterface
    ) {
        self.retrieveNameStatisticsUseCase =
            retrieveNameStatisticsUseCase

        bindActions()
    }

    var canSearch: Bool {
        !name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }

    func search() {
        let value = name
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !value.isEmpty else {
            return
        }

        actionSubject.send(.search(value))
    }

    private func bindActions() {
        actionSubject
            .map { [retrieveNameStatisticsUseCase] action
                -> AnyPublisher<NameStatisticsState, Never> in

                switch action {
                case .search(let name):
                    return retrieveNameStatisticsUseCase
                        .execute(nameRomaji: name)
                        .map { statistics in
                            statistics.isEmpty
                                ? .empty
                                : .loaded(statistics)
                        }
                        .catch { error in
                            Just(
                                NameStatisticsState.failed(
                                    error.localizedDescription
                                )
                            )
                        }
                        .prepend(.loading)
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
