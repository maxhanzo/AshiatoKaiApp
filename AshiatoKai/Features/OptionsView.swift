//
//  OptionsView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 01/10/26.
//

import SwiftUI

struct OptionsView: View {
    var body: some View {
        Form {
            Section {
                ContentUnavailableView("No options yet", systemImage: "gearshape",
                    description: Text("App preferences will appear here when available."))
            }
        }
        .navigationTitle("Options")
    }
}
