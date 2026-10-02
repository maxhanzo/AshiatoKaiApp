//
//  AppContainer.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Foundation

@MainActor
final class AppContainer {
    private let apiClient: any APIClient

    private let searchRepository: any SearchRepository
    private let immigrantGroupRepository: any ImmigrantGroupRepository

    private let retrieveImmigrantsUseCase:
        any RetrieveImmigrantsUseCaseInterface

    private let retrieveImmigrantGroupUseCase:
        any RetrieveImmigrantGroupUseCaseInterface

    init() {
        let apiClient = URLSessionAPIClient()

        let searchRepository = RemoteSearchRepository(
            apiClient: apiClient
        )

        let immigrantGroupRepository = RemoteImmigrantGroupRepository(
            apiClient: apiClient
        )

        let retrieveImmigrantsUseCase = RetrieveImmigrantsUseCase(
            repository: searchRepository
        )

        let retrieveImmigrantGroupUseCase =
            RetrieveImmigrantGroupUseCase(
                repository: immigrantGroupRepository
            )

        self.apiClient = apiClient
        self.searchRepository = searchRepository
        self.immigrantGroupRepository = immigrantGroupRepository
        self.retrieveImmigrantsUseCase = retrieveImmigrantsUseCase
        self.retrieveImmigrantGroupUseCase =
            retrieveImmigrantGroupUseCase
    }

    func makeCoordinator() -> AppCoordinator {
        AppCoordinator(
            searchViewModel: SearchViewModel(
                retrieveImmigrantsUseCase:
                    retrieveImmigrantsUseCase
            ),
            makeGroupDetailsViewModelFactory: { [retrieveImmigrantGroupUseCase] groupID in
                GroupDetailsViewModel(
                    groupID: groupID,
                    retrieveImmigrantGroupUseCase:
                        retrieveImmigrantGroupUseCase
                )
            }
        )
    }
}
