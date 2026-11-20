//
//  RetrieveNameStatisticsUseCaseInterface.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import AshiatoKaiDomain
import Combine

protocol RetrieveNameStatisticsUseCaseInterface {
    func execute(
        nameRomaji: String
    ) -> AnyPublisher<
        [NameStatistics],
        StatisticsError
    >
}
