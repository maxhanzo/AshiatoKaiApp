//
//  URLSessionAPIClient.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import Combine
import Foundation

enum APIError: Error {
    case transport(URLError)
    case nonHTTPResponse
    case server(status: Int, code: String?, message: String?)
    case decoding(Error)
}
