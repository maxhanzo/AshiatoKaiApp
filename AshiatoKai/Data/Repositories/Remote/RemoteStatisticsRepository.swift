//
//  RemoteStatisticsRepository.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import AshiatoKaiDomain
import Combine
import Foundation

final class RemoteStatisticsRepository: StatisticsRepository {

    private let apiClient: APIClient

    init(
        apiClient: APIClient
    ) {
        self.apiClient = apiClient
    }

    // MARK: - Prefectures

    func retrieveTopPrefectures()
        -> AnyPublisher<
            [PrefectureStatistics],
            StatisticsError
        > {

        apiClient
            .execute(
                AshiatoKaiAPI.topPrefectures(),
                as: [PrefectureStatisticsDTO].self
            )
            .map { dtos in
                dtos.map { $0.toDomain() }
            }
            .mapError(APIErrorMapper.statistics)
            .eraseToAnyPublisher()
    }

    func retrievePrefectureStatistics(
        prefecture: String
    ) -> AnyPublisher<
        [PrefectureStatistics],
        StatisticsError
    > {

        apiClient
            .execute(
                AshiatoKaiAPI.prefectureStatistics(
                    prefecture: prefecture
                ),
                as: [PrefectureStatisticsDTO].self
            )
            .map { dtos in
                dtos.map { $0.toDomain() }
            }
            .mapError(APIErrorMapper.statistics)
            .eraseToAnyPublisher()
    }

    // MARK: - Surnames

    func retrieveTopSurnames()
        -> AnyPublisher<
            [SurnameStatistics],
            StatisticsError
        > {

        apiClient
            .execute(
                AshiatoKaiAPI.topSurnames(),
                as: [SurnameStatisticsDTO].self
            )
            .map { dtos in
                dtos.map { $0.toDomain() }
            }
            .mapError(APIErrorMapper.statistics)
            .eraseToAnyPublisher()
    }

    func retrieveSurnameStatistics(
        surnameRomaji: String
    ) -> AnyPublisher<
        [SurnameStatistics],
        StatisticsError
    > {

        apiClient
            .execute(
                AshiatoKaiAPI.surnameStatistics(
                    surnameRomaji: surnameRomaji
                ),
                as: [SurnameStatisticsDTO].self
            )
            .map { dtos in
                dtos.map { $0.toDomain() }
            }
            .mapError(APIErrorMapper.statistics)
            .eraseToAnyPublisher()
    }

    // MARK: - Names

    func retrieveTopNames()
        -> AnyPublisher<
            [NameStatistics],
            StatisticsError
        > {

        apiClient
            .execute(
                AshiatoKaiAPI.topNames(),
                as: [NameStatisticsDTO].self
            )
            .map { dtos in
                dtos.map { $0.toDomain() }
            }
            .mapError(APIErrorMapper.statistics)
            .eraseToAnyPublisher()
    }

    func retrieveNameStatistics(
        nameRomaji: String
    ) -> AnyPublisher<
        [NameStatistics],
        StatisticsError
    > {

        apiClient
            .execute(
                AshiatoKaiAPI.nameStatistics(
                    nameRomaji: nameRomaji
                ),
                as: [NameStatisticsDTO].self
            )
            .map { dtos in
                dtos.map { $0.toDomain() }
            }
            .mapError(APIErrorMapper.statistics)
            .eraseToAnyPublisher()
    }

}
