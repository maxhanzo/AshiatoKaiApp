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
    private let statisticsRepository: any StatisticsRepository
    private let geolocationRepository: any GeolocationRepository

    private let retrieveImmigrantsUseCase:
        any RetrieveImmigrantsUseCaseInterface

    private let retrieveImmigrantGroupUseCase:
        any RetrieveImmigrantGroupUseCaseInterface

    private let retrieveTopPrefecturesUseCase:
        any RetrieveTopPrefecturesUseCaseInterface

    private let retrieveTopSurnamesUseCase:
        any RetrieveTopSurnamesUseCaseInterface

    private let retrievePrefectureStatisticsUseCase:
        any RetrievePrefectureStatisticsUseCaseInterface

    private let retrieveSurnameStatisticsUseCase:
        any RetrieveSurnameStatisticsUseCaseInterface
    
    private let retrieveGeolocationUseCase:
        any RetrieveGeolocationUseCaseInterface

    init() {
        let apiClient = URLSessionAPIClient()

        let searchRepository = RemoteSearchRepository(
            apiClient: apiClient
        )

        let immigrantGroupRepository =
            RemoteImmigrantGroupRepository(
                apiClient: apiClient
            )

        let statisticsRepository =
            RemoteStatisticsRepository(
                apiClient: apiClient
            )
        
        let geolocationRepository =
            RemoteGeolocationRepository(
                apiClient: apiClient
            )

        let retrieveImmigrantsUseCase =
            RetrieveImmigrantsUseCase(
                repository: searchRepository
            )

        let retrieveImmigrantGroupUseCase =
            RetrieveImmigrantGroupUseCase(
                repository: immigrantGroupRepository
            )

        let retrieveTopPrefecturesUseCase =
            RetrieveTopPrefecturesUseCase(
                repository: statisticsRepository
            )

        let retrieveTopSurnamesUseCase =
            RetrieveTopSurnamesUseCase(
                repository: statisticsRepository
            )

        let retrievePrefectureStatisticsUseCase =
            RetrievePrefectureStatisticsUseCase(
                repository: statisticsRepository
            )

        let retrieveSurnameStatisticsUseCase =
            RetrieveSurnameStatisticsUseCase(
                repository: statisticsRepository
            )
        
        let retrieveGeolocationUseCase =
            RetrieveGeolocationUseCase(
                repository: geolocationRepository
            )
        
        self.apiClient = apiClient

        self.searchRepository = searchRepository
        self.immigrantGroupRepository =
            immigrantGroupRepository
        self.statisticsRepository =
            statisticsRepository

        self.retrieveImmigrantsUseCase =
            retrieveImmigrantsUseCase

        self.retrieveImmigrantGroupUseCase =
            retrieveImmigrantGroupUseCase

        self.retrieveTopPrefecturesUseCase =
            retrieveTopPrefecturesUseCase

        self.retrieveTopSurnamesUseCase =
            retrieveTopSurnamesUseCase

        self.retrievePrefectureStatisticsUseCase =
            retrievePrefectureStatisticsUseCase

        self.retrieveSurnameStatisticsUseCase =
            retrieveSurnameStatisticsUseCase
        
        self.geolocationRepository =
            geolocationRepository

        self.retrieveGeolocationUseCase =
            retrieveGeolocationUseCase
    }

    func makeCoordinator() -> AppCoordinator {
        AppCoordinator(
            searchViewModel: SearchViewModel(
                retrieveImmigrantsUseCase:
                    retrieveImmigrantsUseCase
            ),

            statisticsViewModel:
                StatisticsViewModel(),

            makeGroupDetailsViewModelFactory: {
                [retrieveImmigrantGroupUseCase] groupID in

                GroupDetailsViewModel(
                    groupID: groupID,
                    retrieveImmigrantGroupUseCase:
                        retrieveImmigrantGroupUseCase
                )
            },

            makeTopPrefecturesViewModelFactory: {
                [retrieveTopPrefecturesUseCase] in

                TopPrefecturesViewModel(
                    retrieveTopPrefecturesUseCase:
                        retrieveTopPrefecturesUseCase
                )
            },

            makeTopSurnamesViewModelFactory: {
                [retrieveTopSurnamesUseCase] in

                TopSurnamesViewModel(
                    retrieveTopSurnamesUseCase:
                        retrieveTopSurnamesUseCase
                )
            },

            makePrefectureStatisticsViewModelFactory: {
                [retrievePrefectureStatisticsUseCase] in

                PrefectureStatisticsViewModel(
                    retrievePrefectureStatisticsUseCase:
                        retrievePrefectureStatisticsUseCase
                )
            },

            makeSurnameStatisticsViewModelFactory: {
                [retrieveSurnameStatisticsUseCase] in

                SurnameStatisticsViewModel(
                    retrieveSurnameStatisticsUseCase:
                        retrieveSurnameStatisticsUseCase
                )
            },

            makePrefectureDetailViewModelFactory: {
                [retrieveGeolocationUseCase] statistic in

                PrefectureDetailViewModel(
                    statistic: statistic,
                    retrieveGeolocationUseCase:
                        retrieveGeolocationUseCase
                )
            }
        )
    }
}
