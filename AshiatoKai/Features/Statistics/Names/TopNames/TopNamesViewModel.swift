//
//  TopNamesViewModel.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine
import Foundation

@MainActor
final class TopNamesViewModel: ObservableObject {

    @Published private(set) var state: TopNamesState = .idle

    private let retrieveTopNamesUseCase:
        any RetrieveTopNamesUseCaseInterface

    private var cancellables = Set<AnyCancellable>()

    init(
        retrieveTopNamesUseCase:
            any RetrieveTopNamesUseCaseInterface
    ) {
        self.retrieveTopNamesUseCase =
            retrieveTopNamesUseCase
    }

    func load() {
        state = .loading

        retrieveTopNamesUseCase
            .execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }

                    if case .failure(let error) = completion {
                        self.state = .failed(
                            error.localizedDescription
                        )
                    }
                },
                receiveValue: { [weak self] statistics in
                    guard let self else { return }

                    self.state = statistics.isEmpty
                        ? .empty
                        : .loaded(statistics)
                }
            )
            .store(in: &cancellables)
    }
}
