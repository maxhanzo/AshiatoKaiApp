//
//  APIError.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import Foundation
import Combine

enum APIError: Error {
    case transport(URLError)
    case nonHTTPResponse
    case httpStatus(Int)
    case decoding(Error)
}

protocol APIClient {
    func execute<Response: Decodable>(
        _ request: URLRequest,
        as type: Response.Type
    ) -> AnyPublisher<Response, APIError>
}

final class URLSessionAPIClient: APIClient {
    private let session: URLSession
    private let makeDecoder: () -> JSONDecoder

    init(session: URLSession = .shared,
         makeDecoder: @escaping () -> JSONDecoder = { JSONDecoder() }) {
        self.session = session
        self.makeDecoder = makeDecoder
    }

    func execute<Response: Decodable>(
        _ request: URLRequest,
        as type: Response.Type
    ) -> AnyPublisher<Response, APIError> {
        Deferred { [session, makeDecoder] in
            session.dataTaskPublisher(for: request)
                .tryMap { output -> Data in
                    guard let response = output.response as? HTTPURLResponse else {
                        throw APIError.nonHTTPResponse
                    }
                    guard (200..<300).contains(response.statusCode) else {
                        throw APIError.httpStatus(response.statusCode)
                    }
                    return output.data
                }
                .decode(type: type, decoder: makeDecoder())
                .mapError { error -> APIError in
                    if let error = error as? APIError { return error }
                    if let error = error as? URLError { return .transport(error) }
                    return .decoding(error)
                }
        }
        .eraseToAnyPublisher()
    }
}

// Add RemoteSearchRepository after the API contract is supplied.
// It will build a URLRequest, decode DTOs with APIClient, map them to
// SearchRecord and translate APIError into SearchError.
// No endpoint, authentication scheme or response format is invented here.
