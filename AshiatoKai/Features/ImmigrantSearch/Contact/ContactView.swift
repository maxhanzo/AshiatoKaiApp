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
            }

            Section {
                Button {
                    sendEmail()
                } label: {
                    Label("contact.email", systemImage: "envelope")
                }

                Text(email)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("contact.title")
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
