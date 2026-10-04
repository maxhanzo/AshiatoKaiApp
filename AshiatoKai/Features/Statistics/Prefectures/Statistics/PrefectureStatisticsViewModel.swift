//
//  PrefectureStatisticsViewModel.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Combine
import Foundation

@MainActor
final class PrefectureStatisticsViewModel: ObservableObject {

    @Published var prefecture = ""
    @Published private(set) var state: PrefectureStatisticsState = .idle

    private enum Action {
        case search(String)
    }

    private let actionSubject = PassthroughSubject<Action, Never>()

    private let retrievePrefectureStatisticsUseCase:
        any RetrievePrefectureStatisticsUseCaseInterface

    private var cancellables = Set<AnyCancellable>()

    init(
        retrievePrefectureStatisticsUseCase:
            any RetrievePrefectureStatisticsUseCaseInterface
    ) {
        self.retrievePrefectureStatisticsUseCase =
            retrievePrefectureStatisticsUseCase

        bindActions()
    }

    var canSearch: Bool {
        !prefecture
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }

    func search() {
        let value = prefecture
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !value.isEmpty else {
            return
        }

        actionSubject.send(.search(value))
    }

    private func bindActions() {
        actionSubject
            .map { [retrievePrefectureStatisticsUseCase] action
                -> AnyPublisher<PrefectureStatisticsState, Never> in

                switch action {
                case .search(let prefecture):
                    return retrievePrefectureStatisticsUseCase
                        .execute(prefecture: prefecture)
                        .map { statistics in
                            statistics.isEmpty
                                ? .empty
                                : .loaded(statistics)
                        }
                        .catch { error in
                            Just(
                                PrefectureStatisticsState.failed(
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
