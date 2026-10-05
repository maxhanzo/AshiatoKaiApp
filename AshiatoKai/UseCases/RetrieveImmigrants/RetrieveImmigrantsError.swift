//
//  RetrieveImmigrantsError.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Foundation

enum RetrieveImmigrantsError: LocalizedError {
    case noResults

    var errorDescription: String? {
        switch self {
        case .noResults:
            return "No immigrants were found matching your search criteria."
        }
    }
}
