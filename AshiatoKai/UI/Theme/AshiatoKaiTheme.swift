//
//  AshiatoKaiTheme.swift
//  AshiatoKai
//
//  Created by Max Ueda on 06/10/26.
//

import SwiftUI

enum AshiatoKaiTheme {

    // MARK: - Colours

    enum Colour {
        /// Main archival-paper background.
        static let paper = Color(
            light: Color(red: 246 / 255, green: 241 / 255, blue: 231 / 255),
            dark: Color(red: 30 / 255, green: 29 / 255, blue: 27 / 255)
        )

        /// Slightly stronger paper colour for cards and grouped content.
        static let warmPaper = Color(
            light: Color(red: 237 / 255, green: 228 / 255, blue: 212 / 255),
            dark: Color(red: 42 / 255, green: 40 / 255, blue: 36 / 255)
        )
        
        /// Slightly lighter paper colour
        static let lightPaper = Color(
            light: Color(
                red: 250 / 255,
                green: 248 / 255,
                blue: 243 / 255
            ),
            dark: Color(
                red: 36 / 255,
                green: 35 / 255,
                blue: 32 / 255
            )
        )

        /// Primary ink.
        static let sumi = Color(
            light: Color(red: 40 / 255, green: 39 / 255, blue: 36 / 255),
            dark: Color(red: 239 / 255, green: 235 / 255, blue: 226 / 255)
        )

        /// Secondary ink.
        static let mutedSumi = Color(
            light: Color(red: 105 / 255, green: 100 / 255, blue: 92 / 255),
            dark: Color(red: 181 / 255, green: 175 / 255, blue: 164 / 255)
        )

        /// 印-inspired primary accent.
        static let vermilion = Color(
            red: 183 / 255,
            green: 67 / 255,
            blue: 50 / 255
        )

        /// Geography / supporting information.
        static let indigo = Color(
            light: Color(red: 52 / 255, green: 74 / 255, blue: 94 / 255),
            dark: Color(red: 120 / 255, green: 148 / 255, blue: 172 / 255)
        )

        /// Fine separators and writing guides.
        static let hairline = Color(
            light: Color.black.opacity(0.12),
            dark: Color.white.opacity(0.14)
        )
    }

    // MARK: - Typography

    enum Typography {
        static let archiveMark: Font =
            .custom(
                "AvenirNext-DemiBold",
                size: 13,
                relativeTo: .caption
            )

        static let screenTitle: Font =
            .custom(
                "AvenirNext-DemiBold",
                size: 34,
                relativeTo: .largeTitle
            )

        static let sectionTitle: Font =
            .custom(
                "AvenirNext-DemiBold",
                size: 17,
                relativeTo: .headline
            )

        static let recordTitle: Font =
            .custom(
                "AvenirNext-Medium",
                size: 17,
                relativeTo: .headline
            )

        static let body: Font =
            .custom(
                "AvenirNext-Regular",
                size: 17,
                relativeTo: .body
            )

        static let metadata: Font =
            .custom(
                "AvenirNext-Regular",
                size: 15,
                relativeTo: .subheadline
            )

        static let caption: Font =
            .custom(
                "AvenirNext-Regular",
                size: 13,
                relativeTo: .caption
            )

        static let japaneseName: Font =
            .system(
                size: 24,
                weight: .regular,
                design: .serif
            )
    }

    // MARK: - Layout

    enum Layout {
        static let cornerRadius: CGFloat = 12
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 16
    }
}


// MARK: - Adaptive Colour

private extension Color {

    init(light: Color, dark: Color) {
        self.init(
            UIColor { traits in
                traits.userInterfaceStyle == .dark
                    ? UIColor(dark)
                    : UIColor(light)
            }
        )
    }
}
