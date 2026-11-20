//
//  SearchRepository.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import AshiatoKaiDomain
import Combine

protocol SearchRepository {
    func search(criteria: SearchCriteria) -> AnyPublisher<[SearchRecord], SearchError>
}
