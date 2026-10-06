//
//  ArchiveHeader.swift
//  AshiatoKai
//
//  Created by Max Ueda on 06/10/26.
//

import SwiftUI

struct ArchiveHeader: View {

    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey?

    init(
        _ title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("足跡・改")
                .font(AshiatoKaiTheme.Typography.archiveMark)
                .foregroundStyle(AshiatoKaiTheme.Colour.vermilion)

            Text(title)
                .font(AshiatoKaiTheme.Typography.screenTitle)
                .foregroundStyle(AshiatoKaiTheme.Colour.sumi)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AshiatoKaiTheme.Colour.mutedSumi)
            }

            Rectangle()
                .fill(AshiatoKaiTheme.Colour.vermilion)
                .frame(width: 36, height: 2)
                .padding(.top, 3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}
