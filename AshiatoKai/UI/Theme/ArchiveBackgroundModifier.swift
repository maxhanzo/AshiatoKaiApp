//
//  ArchiveBackgroundModifier.swift
//  AshiatoKai
//
//  Created by Max Ueda on 06/10/26.
//

import SwiftUI

private struct ArchiveBackgroundModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(AshiatoKaiTheme.Colour.paper)
            .tint(AshiatoKaiTheme.Colour.vermilion)
    }
}

extension View {

    func ashiatoArchiveStyle() -> some View {
        modifier(ArchiveBackgroundModifier())
    }
}
