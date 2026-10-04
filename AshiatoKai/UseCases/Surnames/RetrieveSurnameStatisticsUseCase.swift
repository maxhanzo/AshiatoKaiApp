//
//  RetrieveSurnameStatisticsUseCase.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Combine

final class RetrieveSurnameStatisticsUseCase:
    RetrieveSurnameStatisticsUseCaseInterface {

    private let repository: StatisticsRepository

    init(repository: StatisticsRepository) {
        self.repository = repository
    }

    func execute(
        surnameRomaji: String
    ) -> AnyPublisher<
        [SurnameStatistics],
        StatisticsError
    > {

        repository.retrieveSurnameStatistics(
            surnameRomaji: surnameRomaji
        )
    }
}
