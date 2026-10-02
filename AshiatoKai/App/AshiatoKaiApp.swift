//
//  AshiatoKaiApp.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import SwiftUI

@main
struct AshiatoKaiApp: App {
    @StateObject private var coordinator: AppCoordinator

    init() {
        let container = AppContainer()
        _coordinator = StateObject(wrappedValue: container.makeCoordinator())
    }

    var body: some Scene {
        WindowGroup { AppView(coordinator: coordinator) }
    }
}

@MainActor
final class AppContainer {
    private let repository: any SearchRepository

    init(repository: (any SearchRepository)? = nil) {
        if let repository {
            self.repository = repository
        } else {
            let apiClient = URLSessionAPIClient()
            self.repository = RemoteSearchRepository(apiClient: apiClient)
        }
    }

    func makeCoordinator() -> AppCoordinator {
        AppCoordinator(searchViewModel: SearchViewModel(repository: repository))
    }
}
