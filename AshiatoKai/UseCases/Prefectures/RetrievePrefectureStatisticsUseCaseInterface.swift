//
//  RetrievePrefectureStatisticsUseCaseInterface.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Combine

protocol RetrievePrefectureStatisticsUseCaseInterface {
    func execute(
        prefecture: String
    ) -> AnyPublisher<
        [PrefectureStatistics],
        StatisticsError
    >
}
