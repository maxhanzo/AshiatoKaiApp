//
//  RetrieveTopPrefecturesUseCaseInterface.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import Combine

protocol RetrieveTopPrefecturesUseCaseInterface {
    func execute()
        -> AnyPublisher<
            [PrefectureStatistics],
            StatisticsError
        >
}
