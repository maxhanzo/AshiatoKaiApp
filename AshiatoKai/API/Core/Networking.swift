//
//  Networking.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import Combine
import Foundation

enum AshiatoKaiAPI {
    static let baseURL = URL(string: "https://ashiato-kai-api.ashiato-kai.workers.dev")!

    static func immigrants(criteria: SearchCriteria) -> URLRequest {
        var components = URLComponents(
            url: baseURL.appending(path: "/api/v1/immigrants"),
            resolvingAgainstBaseURL: false
        )!

        var queryItems = [
            URLQueryItem(name: "NameRomaji", value: criteria.name),
            URLQueryItem(name: "SurnameRomaji", value: criteria.surname)
        ]

        if let year = criteria.year {
            queryItems.append(URLQueryItem(name: "Year", value: String(year)))
        }
        if !criteria.prefecture.isEmpty {
            queryItems.append(URLQueryItem(name: "PrefectureName", value: criteria.prefecture))
        }
        if !criteria.shipName.isEmpty {
            queryItems.append(URLQueryItem(name: "ShipName", value: criteria.shipName))
        }

        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
