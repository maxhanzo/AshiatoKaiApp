//
//  RetrieveImmigrantGroupUseCase.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Combine

final class RetrieveImmigrantGroupUseCase:
    RetrieveImmigrantGroupUseCaseInterface {

    private let repository: any ImmigrantGroupRepository

    init(repository: any ImmigrantGroupRepository) {
        self.repository = repository
    }

    func execute(
        groupID: Int
    ) -> AnyPublisher<ImmigrantGroup, Error> {
        repository.retrieve(groupID: groupID)
    }
}
