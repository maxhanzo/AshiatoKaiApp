//
//  JapaneseCharacterWritingViewModel.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Combine
import Foundation

@MainActor
final class JapaneseCharacterWritingViewModel: ObservableObject {

    @Published private(set) var animationStartDate: Date?
    @Published private(set) var isAnimating = false

    let character: JapaneseCharacter

    let strokeDuration: TimeInterval
    let pauseBetweenStrokes: TimeInterval

    init(
        character: JapaneseCharacter,
        strokeDuration: TimeInterval = 0.8,
        pauseBetweenStrokes: TimeInterval = 0.12
    ) {
        self.character = character
        self.strokeDuration = strokeDuration
        self.pauseBetweenStrokes = pauseBetweenStrokes
    }

    var totalDuration: TimeInterval {
        guard !character.strokes.isEmpty else {
            return 0
        }

        return
            Double(character.strokes.count) * strokeDuration
            +
            Double(character.strokes.count - 1) * pauseBetweenStrokes
    }
    
    func hasCompleted(
        at date: Date
    ) -> Bool {
        guard let animationStartDate else {
            return false
        }

        return date.timeIntervalSince(
            animationStartDate
        ) >= totalDuration
    }

    func play() {
        guard !isAnimating else {
            return
        }

        animationStartDate = Date()
        isAnimating = true
    }

    func replay() {
        animationStartDate = Date()
        isAnimating = true
    }

    func stop() {
        animationStartDate = nil
        isAnimating = false
    }

    func progress(
        forStrokeAt index: Int,
        date: Date
    ) -> CGFloat {
        guard let animationStartDate else {
            return 0
        }

        let elapsed =
            date.timeIntervalSince(animationStartDate)

        let strokeStart =
            Double(index)
            * (strokeDuration + pauseBetweenStrokes)

        let strokeElapsed =
            elapsed - strokeStart

        guard strokeElapsed > 0 else {
            return 0
        }

        guard strokeElapsed < strokeDuration else {
            return 1
        }

        return CGFloat(
            strokeElapsed / strokeDuration
        )
    }

    func updatePlaybackState(
        at date: Date
    ) {
        guard
            isAnimating,
            let animationStartDate
        else {
            return
        }

        if date.timeIntervalSince(animationStartDate)
            >= totalDuration {

            isAnimating = false
        }
    }
}
