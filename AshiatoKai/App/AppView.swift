//
//  AppView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 01/10/26.
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
                        case .results(let records):
                            SearchResultsView(
                                records: records,
                                onRecordSelected: { record in
                                    coordinator.searchViewModel.select(
                                        record
                                    )
                                }
                            )

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
                Label("tab.search", systemImage: "magnifyingglass")
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
                                coordinator.makeTopPrefecturesViewModel(),
                            onPrefectureSelected: { statistic in
                                coordinator.showPrefectureMap(
                                    statistic: statistic
                                )
                            }
                        )

                    case .prefectureSearch:
                        PrefectureStatisticsView(
                            viewModel:
                                coordinator.makePrefectureStatisticsViewModel(),
                            onPrefectureSelected: { statistic in
                                coordinator.showPrefectureMap(
                                    statistic: statistic
                                )
                            }
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

                    case .prefectureMap(let statistic):
                        PrefectureDetailView(
                            viewModel:
                                coordinator.makePrefectureDetailViewModel(
                                    statistic: statistic
                                )
                        )
                    }
                }
            }
            .tabItem {
                Label(
                    "tab.statistics",
                    systemImage: "chart.bar.xaxis"
                )
            }
            .tag(AppTab.statistics)
            .tint(.indigo)
        }
    }
}
