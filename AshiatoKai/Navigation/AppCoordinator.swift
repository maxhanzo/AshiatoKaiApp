//
//  AppCoordinator.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import Combine
import Foundation

enum AppTab: Hashable {
    case search
    case options
}

enum SearchRoute: Hashable {
    case detail(SearchRecord)
    case groupDetails(Int)
    case nameSurnameKanji(ImmigrantGroupMember)
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var selectedTab: AppTab = .search
    @Published var searchPath: [SearchRoute] = []

    let searchViewModel: SearchViewModel

    private let makeGroupDetailsViewModelFactory: (Int) -> GroupDetailsViewModel

    private var cancellables = Set<AnyCancellable>()

    init(
        searchViewModel: SearchViewModel,
        makeGroupDetailsViewModelFactory: @escaping (Int) -> GroupDetailsViewModel
    ) {
        self.searchViewModel = searchViewModel
        self.makeGroupDetailsViewModelFactory = makeGroupDetailsViewModelFactory

        searchViewModel.navigation
            .sink { [weak self] event in
                guard let self else { return }

                switch event {
                case .showDetail(let record):
                    searchPath.append(.detail(record))
                }
            }
            .store(in: &cancellables)
    }

    func showGroupDetails(groupID: Int) {
        searchPath.append(.groupDetails(groupID))
    }
    
    func showNameSurnameKanji(
        member: ImmigrantGroupMember
    ) {
        searchPath.append(.nameSurnameKanji(member))
    }

    func makeGroupDetailsViewModel(
        groupID: Int
    ) -> GroupDetailsViewModel {
        makeGroupDetailsViewModelFactory(groupID)
    }
}
