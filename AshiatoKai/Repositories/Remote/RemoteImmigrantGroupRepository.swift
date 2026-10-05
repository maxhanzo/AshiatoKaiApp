//
//  RemoteImmigrantGroupRepository.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Combine
import Foundation

import Combine
import Foundation

final class RemoteImmigrantGroupRepository: ImmigrantGroupRepository {
    private let apiClient: any APIClient

    init(apiClient: any APIClient) {
        self.apiClient = apiClient
    }

    func retrieve(
        groupID: Int
    ) -> AnyPublisher<ImmigrantGroup, Error> {
        apiClient
            .execute(
                AshiatoKaiAPI.immigrantGroup(groupID: groupID),
                as: ImmigrantGroupDTO.self
            )
            .map { $0.toDomain() }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
