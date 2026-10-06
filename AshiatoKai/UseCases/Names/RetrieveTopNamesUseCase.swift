//
//  RetrieveTopNamesUseCase.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//


import Combine

final class RetrieveTopNamesUseCase:
    RetrieveTopNamesUseCaseInterface {

    private let repository: StatisticsRepository

    init(repository: StatisticsRepository) {
        self.repository = repository
    }

    func execute()
        -> AnyPublisher<
            [NameStatistics],
            StatisticsError
        > {

        repository.retrieveTopNames()
    }
}
