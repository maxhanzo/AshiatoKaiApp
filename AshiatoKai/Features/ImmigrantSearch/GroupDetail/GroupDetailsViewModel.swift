//
//  GroupDetailsViewModel.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Combine
import Foundation

@MainActor
final class GroupDetailsViewModel: ObservableObject {
    @Published private(set) var state: GroupDetailsState = .idle

    let groupID: Int
    let retrieveImmigrantGroupUseCase:
        any RetrieveImmigrantGroupUseCaseInterface

    var cancellables = Set<AnyCancellable>()

    init(
        groupID: Int,
        retrieveImmigrantGroupUseCase:
            any RetrieveImmigrantGroupUseCaseInterface
    ) {
        self.groupID = groupID
        self.retrieveImmigrantGroupUseCase =
            retrieveImmigrantGroupUseCase
    }

    func retrieveGroup() {
        retrieveImmigrantGroupUseCase
            .execute(groupID: groupID)
            .map(GroupDetailsState.loaded)
            .catch {
                Just(
                    GroupDetailsState.failed(
                        $0.localizedDescription
                    )
                )
            }
            .prepend(.loading)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
