//
//  RetrieveTopSurnamesUseCaseInterface.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import AshiatoKaiDomain
import Combine

protocol RetrieveTopSurnamesUseCaseInterface {
    func execute()
        -> AnyPublisher<
            [SurnameStatistics],
            StatisticsError
        >
}
