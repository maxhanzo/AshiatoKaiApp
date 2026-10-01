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
                            RecordDetailView(record: record)
                        }
                    }
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            .tag(AppTab.search)

            NavigationStack {
                OptionsView()
            }
            .tabItem { Label("Options", systemImage: "gearshape") }
            .tag(AppTab.options)
        }
        .tint(.indigo)
    }
}
