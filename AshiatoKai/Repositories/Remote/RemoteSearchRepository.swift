//
//  RemoteSearchRepository.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Combine
import Foundation

struct RemoteSearchRepository: SearchRepository {
    private let apiClient: any APIClient

    init(apiClient: any APIClient) {
        self.apiClient = apiClient
    }

    func search(criteria: SearchCriteria) -> AnyPublisher<[SearchRecord], SearchError> {
        apiClient
            .execute(AshiatoKaiAPI.immigrants(criteria: criteria), as: [ImmigrantDTO].self)
            .map { $0.map(\.domainModel) }
            .mapError(SearchError.init(apiError:))
            .eraseToAnyPublisher()
    }
}
