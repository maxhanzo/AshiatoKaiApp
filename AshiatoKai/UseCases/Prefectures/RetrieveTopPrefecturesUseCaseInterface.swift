//
//  RetrieveTopPrefecturesUseCaseInterface.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine

protocol RetrieveTopPrefecturesUseCaseInterface {
    func execute()
        -> AnyPublisher<
            [PrefectureStatistics],
            StatisticsError
        >
}
