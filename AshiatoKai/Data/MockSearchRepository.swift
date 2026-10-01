//
//  MockSearchRepository.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import Foundation
import Combine

struct MockSearchRepository: SearchRepository {
    // Entirely fictional fixtures, not historical records.
    private let records = [
        SearchRecord(id: "demo-1", name: "Haruto", surname: "Tanaka", year: 1920,
                     prefecture: "Osaka", shipName: "Demo Maru"),
        SearchRecord(id: "demo-2", name: "Yuki", surname: "Sato", year: 1930,
                     prefecture: "Fukuoka", shipName: "Sample Maru"),
        SearchRecord(id: "demo-3", name: "Akira", surname: "Suzuki", year: 1920,
                     prefecture: "Tokyo", shipName: "Demo Maru")
    ]

    func search(criteria: SearchCriteria) -> AnyPublisher<[SearchRecord], SearchError> {
        Deferred {
            Just(records.filter { record in
                matches(record.name, criteria.name)
                && matches(record.surname, criteria.surname)
                && (criteria.year == nil || record.year == criteria.year)
                && matches(record.prefecture, criteria.prefecture)
                && matches(record.shipName, criteria.shipName)
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
