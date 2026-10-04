//
//  AppView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.searchPath) {
                SearchView(viewModel: coordinator.searchViewModel)
                    .navigationDestination(for: SearchRoute.self) { route in
                        switch route {
                        case .detail(let record):
                            RecordDetailView(
                                record: record,
                                onGroupDetails: {
                                    coordinator.showGroupDetails(
                                        groupID: record.groupID
                                    )
                                }
                            )
                            
                        case .groupDetails(let groupID):
                            GroupDetailsView(
                                viewModel: coordinator.makeGroupDetailsViewModel(
                                    groupID: groupID
                                ),
                                onMemberSelected: { member in
                                    coordinator.showNameSurnameKanji(
                                        member: member
                                    )
                                }
                            )
                            
                        case .nameSurnameKanji(let member):
                            NameSurnameKanjiView(member: member)
                        }
                    }
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(AppTab.search)
            
            NavigationStack(path: $coordinator.statisticsPath) {
                StatisticsView(
                    viewModel: coordinator.statisticsViewModel
                )
                .navigationDestination(
                    for: StatisticsRoute.self
                ) { route in
                    switch route {
                    case .topPrefectures:
                        TopPrefecturesView(
                            viewModel:
                                coordinator.makeTopPrefecturesViewModel()
                        )

                    case .prefectureSearch:
                        PrefectureStatisticsView(
                            viewModel:
                                coordinator.makePrefectureStatisticsViewModel()
                        )

                    case .topSurnames:
                        TopSurnamesView(
                            viewModel:
                                coordinator.makeTopSurnamesViewModel(),
                            onSurnameSelected: { statistic in
                                coordinator.showSurnameWriting(
                                    statistic: statistic
                                )
                            }
                        )

                    case .surnameSearch:
                        SurnameStatisticsView(
                            viewModel:
                                coordinator.makeSurnameStatisticsViewModel(),
                            onSurnameSelected: { statistic in
                                coordinator.showSurnameWriting(
                                    statistic: statistic
                                )
                            }
                        )
                        
                    case .surnameWriting(let statistic):
                        SurnameKanjiView(
                            statistic: statistic
                        )
                    }
                }
            }
            .tabItem {
                Label(
                    "Statistics",
                    systemImage: "chart.bar.xaxis"
                )
            }
            .tag(AppTab.statistics)
            .tint(.indigo)
        }
    }
}
