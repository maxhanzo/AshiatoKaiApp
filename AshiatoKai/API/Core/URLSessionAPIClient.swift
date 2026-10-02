//
//  URLSessionAPIClient 2.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Combine
import Foundation

final class URLSessionAPIClient: APIClient {
    private let session: URLSession
    private let makeDecoder: () -> JSONDecoder

    init(
        session: URLSession = .shared,
        makeDecoder: @escaping () -> JSONDecoder = { JSONDecoder() }
    ) {
        self.session = session
        self.makeDecoder = makeDecoder
    }

    func execute<Response: Decodable>(
        _ request: URLRequest,
        as type: Response.Type
    ) -> AnyPublisher<Response, APIError> {
        Deferred { [session, makeDecoder] in
            session.dataTaskPublisher(for: request)
                .mapError(APIError.transport)
                .flatMap { output -> AnyPublisher<Data, APIError> in
                    guard let response = output.response as? HTTPURLResponse else {
                        return Fail(error: .nonHTTPResponse).eraseToAnyPublisher()
                    }

                    guard (200..<300).contains(response.statusCode) else {
                        let envelope = try? makeDecoder().decode(APIErrorEnvelope.self, from: output.data)
                        return Fail(error: .server(
                            status: response.statusCode,
                            code: envelope?.error.code,
                            message: envelope?.error.message
                        ))
                        .eraseToAnyPublisher()
                    }

                    return Just(output.data)
                        .setFailureType(to: APIError.self)
                        .eraseToAnyPublisher()
                }
                .decode(type: type, decoder: makeDecoder())
                .mapError { error -> APIError in
                    if let apiError = error as? APIError { return apiError }
                    return .decoding(error)
                }
        }
        .eraseToAnyPublisher()
    }
}
