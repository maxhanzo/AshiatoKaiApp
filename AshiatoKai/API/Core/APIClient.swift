//
//  APIClient.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Combine
import Foundation

protocol APIClient {
    func execute<Response: Decodable>(
        _ request: URLRequest,
        as type: Response.Type
    ) -> AnyPublisher<Response, APIError>
}
