//
//  RetrieveNameStatisticsUseCase.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine

final class RetrieveNameStatisticsUseCase:
    RetrieveNameStatisticsUseCaseInterface {

    private let repository: StatisticsRepository

    init(repository: StatisticsRepository) {
        self.repository = repository
    }

    func execute(
        nameRomaji: String
    ) -> AnyPublisher<
        [NameStatistics],
        StatisticsError
    > {

        repository.retrieveNameStatistics(
            nameRomaji: nameRomaji
        )
    }
}
