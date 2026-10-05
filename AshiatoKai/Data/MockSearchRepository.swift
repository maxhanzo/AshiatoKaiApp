//
//  MockSearchRepository.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 01/10/26.
//

import Foundation
import Combine

struct MockSearchRepository: SearchRepository {
    private let records = [
        SearchRecord(id: 1, groupID: 1, name: "Haruto", surname: "Tanaka",
                     nameJapanese: nil, surnameJapanese: nil, year: 1920,
                     prefecture: "Osaka", shipName: "Demo Maru", destination: nil,
                     farm: nil, arrivalDate: nil, departureDate: nil),
        SearchRecord(id: 2, groupID: 2, name: "Yuki", surname: "Sato",
                     nameJapanese: nil, surnameJapanese: nil, year: 1930,
                     prefecture: "Fukuoka", shipName: "Sample Maru", destination: nil,
                     farm: nil, arrivalDate: nil, departureDate: nil)
    ]

    func search(criteria: SearchCriteria) -> AnyPublisher<[SearchRecord], SearchError> {
        Deferred {
            Just(records.filter { record in
                matches(record.name, criteria.name)
                && matches(record.surname, criteria.surname)
                && (criteria.year == nil || record.year == criteria.year)
                && matches(record.prefecture ?? "", criteria.prefecture)
                && matches(record.shipName ?? "", criteria.shipName)
            })
            .setFailureType(to: SearchError.self)
            .delay(for: .milliseconds(450), scheduler: DispatchQueue.global(qos: .userInitiated))
        }
        .eraseToAnyPublisher()
    }

    private func matches(_ value: String, _ query: String) -> Bool {
        query.isEmpty || value.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
    }
}
