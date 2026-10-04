//
//  RootView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import SwiftUI

struct RootView: View {

    @ObservedObject var coordinator: AppCoordinator

    @State private var isShowingSplash = true

    var body: some View {
        ZStack {
            if isShowingSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                AppView(
                    coordinator: coordinator
                )
                .transition(.opacity)
            }
        }
        .task {
            guard isShowingSplash else {
                return
            }

            try? await Task.sleep(
                for: .seconds(2.5)
            )

            withAnimation(
                .easeInOut(duration: 0.55)
            ) {
                isShowingSplash = false
            }
        }
    }
}
