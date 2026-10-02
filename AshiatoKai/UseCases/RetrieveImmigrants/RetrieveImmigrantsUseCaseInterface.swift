//
//  RetrieveImmigrantsUseCaseInterface.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Combine

protocol RetrieveImmigrantsUseCaseInterface {
    func execute(
        criteria: SearchCriteria
    ) -> AnyPublisher<[SearchRecord], Error>
}
