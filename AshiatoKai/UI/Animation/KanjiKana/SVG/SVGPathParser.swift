//
//  SVGPathParser.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import CoreGraphics
import Foundation

struct SVGPathParser {

    func parse(_ data: String) throws -> CGPath {
        var scanner = Scanner(data)
        let path = CGMutablePath()

        var currentPoint = CGPoint.zero
        var subpathStart = CGPoint.zero
        var command: Character?

        while !scanner.isAtEnd {
            scanner.skipSeparators()

            if let nextCommand = scanner.scanCommand() {
                command = nextCommand
            }

            guard let command else {
                throw SVGPathParserError.unexpectedToken(
                    scanner.remaining
                )
            }

            switch command {
            case "M":
                let point = try scanner.scanPoint()
                path.move(to: point)

                currentPoint = point
                subpathStart = point

                while scanner.hasNumberAhead {
                    let point = try scanner.scanPoint()
                    path.addLine(to: point)
                    currentPoint = point
                }

            case "m":
                let offset = try scanner.scanPoint()
                let point = CGPoint(
                    x: currentPoint.x + offset.x,
                    y: currentPoint.y + offset.y
                )

                path.move(to: point)

                currentPoint = point
                subpathStart = point

                while scanner.hasNumberAhead {
                    let offset = try scanner.scanPoint()
                    let point = CGPoint(
                        x: currentPoint.x + offset.x,
                        y: currentPoint.y + offset.y
                    )

                    path.addLine(to: point)
                    currentPoint = point
                }

            case "L":
                while scanner.hasNumberAhead {
                    let point = try scanner.scanPoint()
                    path.addLine(to: point)
                    currentPoint = point
                }

            case "l":
                while scanner.hasNumberAhead {
                    let offset = try scanner.scanPoint()
                    let point = CGPoint(
                        x: currentPoint.x + offset.x,
                        y: currentPoint.y + offset.y
                    )

                    path.addLine(to: point)
                    currentPoint = point
                }

            case "H":
                while scanner.hasNumberAhead {
                    let x = try scanner.scanNumber()
                    let point = CGPoint(
                        x: x,
                        y: currentPoint.y
                    )

                    path.addLine(to: point)
                    currentPoint = point
                }

            case "h":
                while scanner.hasNumberAhead {
                    let x = try scanner.scanNumber()
                    let point = CGPoint(
                        x: currentPoint.x + x,
                        y: currentPoint.y
                    )

                    path.addLine(to: point)
                    currentPoint = point
                }

            case "V":
                while scanner.hasNumberAhead {
                    let y = try scanner.scanNumber()
                    let point = CGPoint(
                        x: currentPoint.x,
                        y: y
                    )

                    path.addLine(to: point)
                    currentPoint = point
                }

            case "v":
                while scanner.hasNumberAhead {
                    let y = try scanner.scanNumber()
                    let point = CGPoint(
                        x: currentPoint.x,
                        y: currentPoint.y + y
                    )

                    path.addLine(to: point)
                    currentPoint = point
                }

            case "C":
                while scanner.hasNumberAhead {
                    let control1 = try scanner.scanPoint()
                    let control2 = try scanner.scanPoint()
                    let destination = try scanner.scanPoint()

                    path.addCurve(
                        to: destination,
                        control1: control1,
                        control2: control2
                    )

                    currentPoint = destination
                }

            case "c":
                while scanner.hasNumberAhead {
                    let control1Offset = try scanner.scanPoint()
                    let control2Offset = try scanner.scanPoint()
                    let destinationOffset = try scanner.scanPoint()

                    let control1 = CGPoint(
                        x: currentPoint.x + control1Offset.x,
                        y: currentPoint.y + control1Offset.y
                    )

                    let control2 = CGPoint(
                        x: currentPoint.x + control2Offset.x,
                        y: currentPoint.y + control2Offset.y
                    )

                    let destination = CGPoint(
                        x: currentPoint.x + destinationOffset.x,
                        y: currentPoint.y + destinationOffset.y
                    )

                    path.addCurve(
                        to: destination,
                        control1: control1,
                        control2: control2
                    )

                    currentPoint = destination
                }
                
            case "Q":
                while scanner.hasNumberAhead {
                    let control = try scanner.scanPoint()
                    let destination = try scanner.scanPoint()

                    path.addQuadCurve(
                        to: destination,
                        control: control
                    )

                    currentPoint = destination
                }

            case "q":
                while scanner.hasNumberAhead {
                    let controlOffset = try scanner.scanPoint()
                    let destinationOffset = try scanner.scanPoint()

                    let control = CGPoint(
                        x: currentPoint.x + controlOffset.x,
                        y: currentPoint.y + controlOffset.y
                    )

                    let destination = CGPoint(
                        x: currentPoint.x + destinationOffset.x,
                        y: currentPoint.y + destinationOffset.y
                    )

                    path.addQuadCurve(
                        to: destination,
                        control: control
                    )

                    currentPoint = destination
                }

            case "Z", "z":
                path.closeSubpath()
                currentPoint = subpathStart

            default:
                throw SVGPathParserError.unsupportedCommand(
                    command
                )
            }
        }

        return path
    }
    
    
}

