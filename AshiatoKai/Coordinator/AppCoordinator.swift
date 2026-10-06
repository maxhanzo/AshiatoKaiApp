//
//  AppCoordinator.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 01/10/26.
//

import Combine
import Foundation

enum AppTab: Hashable {
    case search
    case statistics
}

enum SearchRoute: Hashable {
    case results([SearchRecord])
    case detail(SearchRecord)
    case groupDetails(Int)
    case nameSurnameKanji(ImmigrantGroupMember)
}

enum StatisticsRoute: Hashable {
    case topPrefectures
    case prefectureSearch
    case topSurnames
    case surnameSearch
    case surnameWriting(SurnameStatistics)
    case topNames
    case nameSearch
    case nameWriting(NameStatistics)
    case prefectureMap(PrefectureStatistics)
}

@MainActor
final class AppCoordinator: ObservableObject {

    @Published var selectedTab: AppTab = .search
    @Published var searchPath: [SearchRoute] = []
    @Published var statisticsPath: [StatisticsRoute] = []

    let searchViewModel: SearchViewModel
    let statisticsViewModel: StatisticsViewModel
    

    private let makeGroupDetailsViewModelFactory:
        (Int) -> GroupDetailsViewModel

    private let makeTopPrefecturesViewModelFactory:
        () -> TopPrefecturesViewModel
    
    private let makeTopSurnamesViewModelFactory:
        () -> TopSurnamesViewModel
    
    private let makePrefectureStatisticsViewModelFactory:
        () -> PrefectureStatisticsViewModel
    
    private let makeSurnameStatisticsViewModelFactory:
        () -> SurnameStatisticsViewModel

    private let makeTopNamesViewModelFactory:
        () -> TopNamesViewModel

    private let makeNameStatisticsViewModelFactory:
        () -> NameStatisticsViewModel
    
    private let makePrefectureDetailViewModelFactory:
        (PrefectureStatistics) -> PrefectureDetailViewModel

    private var cancellables = Set<AnyCancellable>()

    init(
        searchViewModel: SearchViewModel,
        statisticsViewModel: StatisticsViewModel,
        makeGroupDetailsViewModelFactory:
            @escaping (Int) -> GroupDetailsViewModel,
        makeTopPrefecturesViewModelFactory:
            @escaping () -> TopPrefecturesViewModel,
        makeTopSurnamesViewModelFactory:
            @escaping () -> TopSurnamesViewModel,
        makePrefectureStatisticsViewModelFactory:
            @escaping () -> PrefectureStatisticsViewModel,
        makeSurnameStatisticsViewModelFactory:
            @escaping () -> SurnameStatisticsViewModel,
        makeTopNamesViewModelFactory:
            @escaping () -> TopNamesViewModel,
        makeNameStatisticsViewModelFactory:
            @escaping () -> NameStatisticsViewModel,
        makePrefectureDetailViewModelFactory:
            @escaping (PrefectureStatistics) -> PrefectureDetailViewModel
    ) {
        self.searchViewModel = searchViewModel
        
        self.statisticsViewModel = statisticsViewModel
        
        self.makeGroupDetailsViewModelFactory =
            makeGroupDetailsViewModelFactory
        
        self.makeTopPrefecturesViewModelFactory =
            makeTopPrefecturesViewModelFactory
        
        self.makeTopSurnamesViewModelFactory =
            makeTopSurnamesViewModelFactory
        
        self.makePrefectureStatisticsViewModelFactory =
            makePrefectureStatisticsViewModelFactory
        
        self.makeSurnameStatisticsViewModelFactory =
            makeSurnameStatisticsViewModelFactory

        self.makeTopNamesViewModelFactory =
            makeTopNamesViewModelFactory

        self.makeNameStatisticsViewModelFactory =
            makeNameStatisticsViewModelFactory
        
        self.makePrefectureDetailViewModelFactory =
            makePrefectureDetailViewModelFactory

        bindSearchNavigation()
        bindStatisticsNavigation()
    }

    private func bindSearchNavigation() {
        searchViewModel.navigation
            .sink { [weak self] event in
                guard let self else { return }

                switch event {
                case .showResults(let records):
                    searchPath.append(.results(records))

                case .showDetail(let record):
                    searchPath.append(.detail(record))
                }
            }
            .store(in: &cancellables)
    }

    private func bindStatisticsNavigation() {
        statisticsViewModel.navigationPublisher
            .sink { [weak self] event in
                guard let self else { return }

                switch event {
                case .showTopPrefectures:
                    statisticsPath.append(.topPrefectures)

                case .showPrefectureSearch:
                    statisticsPath.append(.prefectureSearch)

                case .showTopSurnames:
                    statisticsPath.append(.topSurnames)

                case .showSurnameSearch:
                    statisticsPath.append(.surnameSearch)

                case .showTopNames:
                    statisticsPath.append(.topNames)

                case .showNameSearch:
                    statisticsPath.append(.nameSearch)
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

    func makeTopPrefecturesViewModel()
        -> TopPrefecturesViewModel {

        makeTopPrefecturesViewModelFactory()
    }
    
    func makeTopSurnamesViewModel()
        -> TopSurnamesViewModel {

        makeTopSurnamesViewModelFactory()
    }
    
    func makePrefectureStatisticsViewModel()
        -> PrefectureStatisticsViewModel {

        makePrefectureStatisticsViewModelFactory()
    }
    
    func makeSurnameStatisticsViewModel()
        -> SurnameStatisticsViewModel {

        makeSurnameStatisticsViewModelFactory()
    }
    
    func makeTopNamesViewModel()
        -> TopNamesViewModel {

        makeTopNamesViewModelFactory()
    }

    func makeNameStatisticsViewModel()
        -> NameStatisticsViewModel {

        makeNameStatisticsViewModelFactory()
    }

    func makePrefectureDetailViewModel(
        statistic: PrefectureStatistics
    ) -> PrefectureDetailViewModel {
        makePrefectureDetailViewModelFactory(
            statistic
        )
    }
    
    func showSurnameWriting(
        statistic: SurnameStatistics
    ) {
        statisticsPath.append(
            .surnameWriting(statistic)
        )
    }
    
    func showNameWriting(
        statistic: NameStatistics
    ) {
        statisticsPath.append(
            .nameWriting(statistic)
        )
    }
    
    func showPrefectureMap(
        statistic: PrefectureStatistics
    ) {
        statisticsPath.append(
            .prefectureMap(statistic)
        )
    }
    
}
