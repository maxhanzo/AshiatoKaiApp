//
//  TopSurnamesViewModel.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Combine
import Foundation

@MainActor
final class TopSurnamesViewModel: ObservableObject {

    @Published private(set) var state: TopSurnamesState = .idle

    private let retrieveTopSurnamesUseCase:
        any RetrieveTopSurnamesUseCaseInterface

    private var cancellables = Set<AnyCancellable>()

    init(
        retrieveTopSurnamesUseCase:
            any RetrieveTopSurnamesUseCaseInterface
    ) {
        self.retrieveTopSurnamesUseCase =
            retrieveTopSurnamesUseCase
    }

    func load() {
        state = .loading

        retrieveTopSurnamesUseCase
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
