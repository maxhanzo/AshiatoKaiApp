//
//  TopPrefecturesViewModel.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Combine
import Foundation

@MainActor
final class TopPrefecturesViewModel: ObservableObject {

    @Published private(set) var state: TopPrefecturesState = .idle

    private let retrieveTopPrefecturesUseCase:
        any RetrieveTopPrefecturesUseCaseInterface

    private var cancellables = Set<AnyCancellable>()

    init(
        retrieveTopPrefecturesUseCase:
            any RetrieveTopPrefecturesUseCaseInterface
    ) {
        self.retrieveTopPrefecturesUseCase =
            retrieveTopPrefecturesUseCase
    }

    func load() {
        state = .loading

        retrieveTopPrefecturesUseCase
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
