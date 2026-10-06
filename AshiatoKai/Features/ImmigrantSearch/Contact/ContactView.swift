//
//  ContactView.swift
//  AshiatoKai
//
//  Created by Max Ueda on 06/10/26.
//

import SwiftUI

struct ContactView: View {
    @Environment(\.openURL) private var openURL

    private let email = "ashiato-kai@uedasoft-it.com"

    var body: some View {
        Form {
            Section {
                Text("contact.description")
                    .font(AshiatoKaiTheme.Typography.body)
                    .foregroundStyle(AshiatoKaiTheme.Colour.sumi)
                    .padding(.vertical, 4)
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)

            Section {
                Button {
                    sendEmail()
                } label: {
                    Label("contact.email", systemImage: "envelope")
                        .font(AshiatoKaiTheme.Typography.body)
                        .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)
                }

                Text(email)
                    .font(AshiatoKaiTheme.Typography.caption)
                    .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)
                    .textSelection(.enabled)
            }
            .listRowBackground(AshiatoKaiTheme.Colour.lightPaper)
        }
        .navigationTitle("contact.title")
        .navigationBarTitleDisplayMode(.inline)
        .ashiatoArchiveStyle()
    }

    private func sendEmail() {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = email
        components.queryItems = [
            URLQueryItem(
                name: "subject",
                value: "Ashiato Kai"
            )
        ]

        if let url = components.url {
            openURL(url)
        }
    }
}
