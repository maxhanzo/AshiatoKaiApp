//
//  StatisticsViewModel.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Combine
import Foundation

@MainActor
final class StatisticsViewModel: ObservableObject {

    // MARK: - Navigation

    private let navigationSubject =
        PassthroughSubject<StatisticsNavigationEvent, Never>()

    var navigationPublisher:
        AnyPublisher<StatisticsNavigationEvent, Never> {
        navigationSubject.eraseToAnyPublisher()
    }

    // MARK: - Actions

    func showTopPrefectures() {
        navigationSubject.send(.showTopPrefectures)
    }

    func showPrefectureSearch() {
        navigationSubject.send(.showPrefectureSearch)
    }

    func showTopSurnames() {
        navigationSubject.send(.showTopSurnames)
    }

    func showSurnameSearch() {
        navigationSubject.send(.showSurnameSearch)
    }
}
