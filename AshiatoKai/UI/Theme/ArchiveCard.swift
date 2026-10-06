//
//  ArchiveCard.swift
//  AshiatoKai
//
//  Created by Max Ueda on 06/10/26.
//

import SwiftUI

struct ArchiveCard<Content: View>: View {

    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(AshiatoKaiTheme.Layout.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(
                    cornerRadius: AshiatoKaiTheme.Layout.cornerRadius,
                    style: .continuous
                )
                .fill(AshiatoKaiTheme.Colour.warmPaper)
            }
    }
}
