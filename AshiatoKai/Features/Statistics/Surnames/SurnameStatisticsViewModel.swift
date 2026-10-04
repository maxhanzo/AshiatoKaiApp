//
//  SurnameStatisticsViewModel.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Combine
import Foundation

@MainActor
final class SurnameStatisticsViewModel: ObservableObject {

    @Published var surname = ""
    @Published private(set) var state: SurnameStatisticsState = .idle

    private enum Action {
        case search(String)
    }

    private let actionSubject = PassthroughSubject<Action, Never>()

    private let retrieveSurnameStatisticsUseCase:
        any RetrieveSurnameStatisticsUseCaseInterface

    private var cancellables = Set<AnyCancellable>()

    init(
        retrieveSurnameStatisticsUseCase:
            any RetrieveSurnameStatisticsUseCaseInterface
    ) {
        self.retrieveSurnameStatisticsUseCase =
            retrieveSurnameStatisticsUseCase

        bindActions()
    }

    var canSearch: Bool {
        !surname
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }

    func search() {
        let value = surname
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !value.isEmpty else {
            return
        }

        actionSubject.send(.search(value))
    }

    private func bindActions() {
        actionSubject
            .map { [retrieveSurnameStatisticsUseCase] action
                -> AnyPublisher<SurnameStatisticsState, Never> in

                switch action {
                case .search(let surname):
                    return retrieveSurnameStatisticsUseCase
                        .execute(surnameRomaji: surname)
                        .map { statistics in
                            statistics.isEmpty
                                ? .empty
                                : .loaded(statistics)
                        }
                        .catch { error in
                            Just(
                                SurnameStatisticsState.failed(
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
