//
//  PrefectureDetailViewModel.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine
import Foundation

@MainActor
final class PrefectureDetailViewModel: ObservableObject {

    @Published private(set) var state: PrefectureDetailState = .idle

    let statistic: PrefectureStatistics

    private let retrieveGeolocationUseCase:
        any RetrieveGeolocationUseCaseInterface

    private var cancellables = Set<AnyCancellable>()

    init(
        statistic: PrefectureStatistics,
        retrieveGeolocationUseCase:
            any RetrieveGeolocationUseCaseInterface
    ) {
        self.statistic = statistic
        self.retrieveGeolocationUseCase =
            retrieveGeolocationUseCase
    }

    func load() {
        guard case .idle = state else {
            return
        }

        state = .loading

        retrieveGeolocationUseCase
            .execute(
                name: statistic.prefectureName
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else {
                        return
                    }

                    if case .failure(let error) = completion {
                        self.state = .failed(
                            error.localizedDescription
                        )
                    }
                },
                receiveValue: { [weak self] geolocation in
                    self?.state = .loaded(
                        geolocation
                    )
                }
            )
            .store(in: &cancellables)
    }
}
