//
//  RetrieveSurnameStatisticsUseCaseInterface.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine

protocol RetrieveSurnameStatisticsUseCaseInterface {
    func execute(
        surnameRomaji: String
    ) -> AnyPublisher<
        [SurnameStatistics],
        StatisticsError
    >
}
