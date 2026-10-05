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
            Color.white
                .ignoresSafeArea()

            Image("AshiatoKaiSplash")
                .resizable()
                .scaledToFit()
                .frame(
                    maxWidth: 320,
                    maxHeight: 320
                )
                .padding(32)
        }
    }
}
