//
//  RetrieveTopSurnamesUseCase.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//


import Combine

final class RetrieveTopSurnamesUseCase:
    RetrieveTopSurnamesUseCaseInterface {

    private let repository: StatisticsRepository

    init(repository: StatisticsRepository) {
        self.repository = repository
    }

    func execute()
        -> AnyPublisher<
            [SurnameStatistics],
            StatisticsError
        > {

        repository.retrieveTopSurnames()
    }
}
