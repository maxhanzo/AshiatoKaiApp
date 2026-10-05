//
//  AnimCJKParser.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import CoreGraphics
import Foundation

struct AnimCJKParser {

    private let pathParser = SVGPathParser()

    func parse(
        character: Character,
        data: Data
    ) throws -> JapaneseCharacter {
        let delegate = AnimCJKXMLDelegate()

        let parser = XMLParser(data: data)
        parser.delegate = delegate

        guard parser.parse() else {
            let message =
                parser.parserError?.localizedDescription ??
                "Unknown XML parsing error."

            throw AnimCJKParserError.xmlParsingFailed(
                message
            )
        }

        var strokesByOrder:
            [Int: [JapaneseStrokeComponent]] = [:]

        for drawingPath in delegate.drawingPaths {
            guard let shapeData =
                    delegate.shapePaths[
                        drawingPath.shapeIdentifier
                    ] else {
                throw AnimCJKParserError.missingShapePath(
                    drawingPath.shapeIdentifier
                )
            }

            let shapePath: CGPath

            do {
                shapePath = try pathParser.parse(
                    shapeData
                )
            } catch {
                throw AnimCJKParserError.invalidShapePath(
                    drawingPath.shapeIdentifier
                )
            }

            let animationPath: CGPath

            do {
                animationPath = try pathParser.parse(
                    drawingPath.pathData
                )
            } catch {
                throw AnimCJKParserError.invalidDrawingPath(
                    drawingPath.shapeIdentifier
                )
            }

            let component = JapaneseStrokeComponent(
                shapePath: shapePath,
                drawingPath: animationPath
            )

            strokesByOrder[
                drawingPath.strokeOrder,
                default: []
            ].append(component)
        }

        let strokes = strokesByOrder
            .keys
            .sorted()
            .map { order in
                JapaneseStroke(
                    order: order,
                    components:
                        strokesByOrder[order] ?? []
                )
            }

        guard !strokes.isEmpty else {
            throw AnimCJKParserError.noStrokesFound(
                character
            )
        }

        return JapaneseCharacter(
            character: character,
            strokes: strokes
        )
    }
}
