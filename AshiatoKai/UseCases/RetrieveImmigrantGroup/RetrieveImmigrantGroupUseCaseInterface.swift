//
//  RetrieveImmigrantGroupUseCaseInterface.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Combine

protocol RetrieveImmigrantGroupUseCaseInterface {
    func execute(
        groupID: Int
    ) -> AnyPublisher<ImmigrantGroup, Error>
}
