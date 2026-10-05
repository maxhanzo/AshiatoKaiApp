//
//  AshiatoKaiAPI.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 01/10/26.
//

import Combine
import Foundation

enum AshiatoKaiAPI {

    static let baseURL = URL(
        string: "https://ashiato-kai-api.ashiato-kai.workers.dev"
    )!

    // MARK: - Immigrants

    static func immigrants(
        criteria: SearchCriteria
    ) -> URLRequest {
        var components = URLComponents(
            url: baseURL.appending(
                path: "/api/v1/immigrants"
            ),
            resolvingAgainstBaseURL: false
        )!

        var queryItems: [URLQueryItem] = []

        if !criteria.name.isEmpty {
            queryItems.append(
                URLQueryItem(
                    name: "NameRomaji",
                    value: criteria.name
                )
            )
        }

        if !criteria.surname.isEmpty {
            queryItems.append(
                URLQueryItem(
                    name: "SurnameRomaji",
                    value: criteria.surname
                )
            )
        }

        if let year = criteria.year {
            queryItems.append(
                URLQueryItem(
                    name: "Year",
                    value: String(year)
                )
            )
        }

        if !criteria.prefecture.isEmpty {
            queryItems.append(
                URLQueryItem(
                    name: "PrefectureName",
                    value: criteria.prefecture
                )
            )
        }

        if !criteria.shipName.isEmpty {
            queryItems.append(
                URLQueryItem(
                    name: "ShipName",
                    value: criteria.shipName
                )
            )
        }

        components.queryItems = queryItems

        return makeGETRequest(
            url: components.url!
        )
    }

    // MARK: - Groups

    static func immigrantGroup(
        groupID: Int
    ) -> URLRequest {
        let url = baseURL
            .appending(path: "/api/v1/groups")
            .appending(path: String(groupID))

        return makeGETRequest(url: url)
    }

    // MARK: - Statistics - Prefectures

    static func topPrefectures() -> URLRequest {
        let url = baseURL.appending(
            path: "/api/v1/statistics/prefectures/top"
        )

        return makeGETRequest(url: url)
    }

    static func prefectureStatistics(
        prefecture: String
    ) -> URLRequest {
        var components = URLComponents(
            url: baseURL.appending(
                path: "/api/v1/statistics/prefectures"
            ),
            resolvingAgainstBaseURL: false
        )!

        components.queryItems = [
            URLQueryItem(
                name: "PrefectureName",
                value: prefecture
            )
        ]

        return makeGETRequest(
            url: components.url!
        )
    }

    // MARK: - Statistics - Surnames

    static func topSurnames() -> URLRequest {
        let url = baseURL.appending(
            path: "/api/v1/statistics/surnames/top"
        )

        return makeGETRequest(url: url)
    }

    static func surnameStatistics(
        surnameRomaji: String
    ) -> URLRequest {
        var components = URLComponents(
            url: baseURL.appending(
                path: "/api/v1/statistics/surnames"
            ),
            resolvingAgainstBaseURL: false
        )!

        components.queryItems = [
            URLQueryItem(
                name: "SurnameRomaji",
                value: surnameRomaji
            )
        ]

        return makeGETRequest(
            url: components.url!
        )
    }

    // MARK: - Geolocation

    static func geolocation() -> URLRequest {
        let url = baseURL.appending(
            path: "/api/v1/geolocation"
        )

        return makeGETRequest(url: url)
    }

    static func geolocation(
        name: String
    ) -> URLRequest {
        let url = baseURL
            .appending(path: "/api/v1/geolocation")
            .appending(path: name)

        return makeGETRequest(url: url)
    }

    // MARK: - Request Construction

    private static func makeGETRequest(
        url: URL
    ) -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        return request
    }
}
