//
//  RetrievePrefectureStatisticsUseCase.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//


import Combine

final class RetrievePrefectureStatisticsUseCase:
    RetrievePrefectureStatisticsUseCaseInterface {

    private let repository: StatisticsRepository

    init(repository: StatisticsRepository) {
        self.repository = repository
    }

    func execute(
        prefecture: String
    ) -> AnyPublisher<
        [PrefectureStatistics],
        StatisticsError
    > {

        repository.retrievePrefectureStatistics(
            prefecture: prefecture
        )
    }
}
