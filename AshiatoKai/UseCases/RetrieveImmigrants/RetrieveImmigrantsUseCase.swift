//
//  DefaultRetrieveImmigrantsUseCase.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Combine

final class RetrieveImmigrantsUseCase: RetrieveImmigrantsUseCaseInterface {

    private let repository: any SearchRepository

    init(repository: any SearchRepository) {
        self.repository = repository
    }

    func execute(
        criteria: SearchCriteria
    ) -> AnyPublisher<[SearchRecord], Error> {

        repository
            .search(criteria: criteria)
            .tryMap { records in
                guard !records.isEmpty else {
                    throw RetrieveImmigrantsError.noResults
                }

                return records
            }
            .eraseToAnyPublisher()
    }
}
