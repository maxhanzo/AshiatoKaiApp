//
//  StatisticsRepository.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine

protocol StatisticsRepository {
    func retrieveTopPrefectures()
        -> AnyPublisher<[PrefectureStatistics], StatisticsError>

    func retrievePrefectureStatistics(
        prefecture: String
    ) -> AnyPublisher<[PrefectureStatistics], StatisticsError>

    func retrieveTopSurnames()
        -> AnyPublisher<[SurnameStatistics], StatisticsError>

    func retrieveSurnameStatistics(
        surnameRomaji: String
    ) -> AnyPublisher<[SurnameStatistics], StatisticsError>
}
