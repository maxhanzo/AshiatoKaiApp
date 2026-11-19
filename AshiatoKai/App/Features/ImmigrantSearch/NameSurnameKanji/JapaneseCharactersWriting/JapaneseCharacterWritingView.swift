//
//  JapaneseCharacterWritingView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import SwiftUI

struct JapaneseCharacterWritingView: View {

    @StateObject private var viewModel:
        JapaneseCharacterWritingViewModel
    
    @State private var didComplete = false
    
    let onCompleted: () -> Void
    

    init(
        character: JapaneseCharacter,
        onCompleted: @escaping () -> Void = {}
    ) {
        self.onCompleted = onCompleted

        _viewModel = StateObject(
            wrappedValue:
                JapaneseCharacterWritingViewModel(
                    character: character
                )
        )
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                draw(
                    in: &context,
                    size: size,
                    date: timeline.date
                )
            }
            .onChange(of: timeline.date) { _, newDate in
                guard
                    !didComplete,
                    viewModel.hasCompleted(at: newDate)
                else {
                    return
                }

                didComplete = true
                onCompleted()
            }
        }
        .onAppear {
            didComplete = false
            viewModel.play()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
    
    private func draw(
        in context: inout GraphicsContext,
        size: CGSize,
        date: Date
    ) {
        let scale = min(
            size.width / 1024,
            size.height / 1024
        )

        var transform = CGAffineTransform(
            scaleX: scale,
            y: scale
        )

        for (index, stroke) in
            viewModel.character.strokes.enumerated() {

            let progress = viewModel.progress(
                forStrokeAt: index,
                date: date
            )

            guard progress > 0 else {
                continue
            }

            for component in stroke.components {
                guard
                    let shapePath =
                        component.shapePath.copy(
                            using: &transform
                        ),
                    let drawingPath =
                        component.drawingPath.copy(
                            using: &transform
                        )
                else {
                    continue
                }

                draw(
                    shapePath: shapePath,
                    drawingPath: drawingPath,
                    progress: progress,
                    scale: scale,
                    in: &context
                )
            }
        }
    }

    private func draw(
        shapePath: CGPath,
        drawingPath: CGPath,
        progress: CGFloat,
        scale: CGFloat,
        in context: inout GraphicsContext
    ) {
        let shape = Path(shapePath)

        context.drawLayer { layer in
            layer.clip(to: shape)

            let trajectory =
                Path(drawingPath)
                    .trimmedPath(
                        from: 0,
                        to: progress
                    )

            layer.stroke(
                trajectory,
                with: .foreground,
                style: StrokeStyle(
                    lineWidth: 128 * scale,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        }
    }
}
