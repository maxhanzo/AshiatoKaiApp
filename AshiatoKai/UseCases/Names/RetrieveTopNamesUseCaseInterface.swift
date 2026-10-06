//
//  RetrieveTopNamesUseCaseInterface.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import Combine

protocol RetrieveTopNamesUseCaseInterface {
    func execute()
        -> AnyPublisher<
            [NameStatistics],
            StatisticsError
        >
}
