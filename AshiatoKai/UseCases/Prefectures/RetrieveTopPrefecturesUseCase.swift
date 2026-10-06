//
//  RetrieveTopPrefecturesUseCase.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine

final class RetrieveTopPrefecturesUseCase:
    RetrieveTopPrefecturesUseCaseInterface {

    private let repository: StatisticsRepository

    init(repository: StatisticsRepository) {
        self.repository = repository
    }

    func execute()
        -> AnyPublisher<
            [PrefectureStatistics],
            StatisticsError
        > {

        repository.retrieveTopPrefectures()
    }
}
