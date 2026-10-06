//
//  SplashView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI

struct SplashView: View {

    var body: some View {
        ZStack {
            AshiatoKaiTheme.Colour.paper
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Image("AshiatoKaiSplash")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        maxWidth: 300,
                        maxHeight: 300
                    )
                    .padding(.horizontal, 32)

                VStack(spacing: 4) {
                    Text("Ashiato Kai")
                        .font(AshiatoKaiTheme.Typography.sectionTitle)
                        .foregroundStyle(AshiatoKaiTheme.Colour.sumi)

                    Text("splash.subtitle")
                        .font(AshiatoKaiTheme.Typography.caption)
                        .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)
                }
            }
        }
    }
}
