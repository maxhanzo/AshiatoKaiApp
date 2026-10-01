//
//  AppCoordinator.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import Foundation
import Combine

enum AppTab: Hashable { case search, options }
enum SearchRoute: Hashable { case detail(SearchRecord) }

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var selectedTab: AppTab = .search
    @Published var searchPath: [SearchRoute] = []
    let searchViewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()

    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
        searchViewModel.navigation
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .showDetail(let record):
                    self.searchPath.append(.detail(record))
                }
            }
            .store(in: &cancellables)
    }
}
