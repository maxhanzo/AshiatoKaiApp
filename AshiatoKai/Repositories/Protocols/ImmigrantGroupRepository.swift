//
//  ImmigrantGroupRepository.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Combine

protocol ImmigrantGroupRepository {
    func retrieve(
        groupID: Int
    ) -> AnyPublisher<ImmigrantGroup, Error>
}
