//
//  Scanner.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import CoreGraphics

struct Scanner {

    private let characters: [Character]
    private(set) var index = 0

    init(_ string: String) {
        characters = Array(string)
    }

    var isAtEnd: Bool {
        index >= characters.count
    }

    var remaining: String {
        guard !isAtEnd else {
            return ""
        }

        return String(characters[index...])
    }

    var hasNumberAhead: Bool {
        var copy = self
        copy.skipSeparators()

        guard !copy.isAtEnd else {
            return false
        }

        let character = copy.characters[copy.index]

        return character.isNumber ||
            character == "-" ||
            character == "+" ||
            character == "."
    }

    mutating func skipSeparators() {
        while !isAtEnd {
            let character = characters[index]

            if character.isWhitespace || character == "," {
                index += 1
            } else {
                break
            }
        }
    }

    mutating func scanCommand() -> Character? {
        skipSeparators()

        guard !isAtEnd else {
            return nil
        }

        let character = characters[index]

        guard character.isLetter else {
            return nil
        }

        index += 1
        return character
    }

    mutating func scanPoint() throws -> CGPoint {
        let x = try scanNumber()
        let y = try scanNumber()

        return CGPoint(
            x: x,
            y: y
        )
    }

    mutating func scanNumber() throws -> CGFloat {
        skipSeparators()

        guard !isAtEnd else {
            throw SVGPathParserError.missingNumber
        }

        let start = index

        if characters[index] == "+" ||
            characters[index] == "-" {
            index += 1
        }

        var hasDecimalPoint = false
        var hasExponent = false

        while !isAtEnd {
            let character = characters[index]

            if character.isNumber {
                index += 1
                continue
            }

            if character == "." && !hasDecimalPoint {
                hasDecimalPoint = true
                index += 1
                continue
            }

            if (character == "e" || character == "E") &&
                !hasExponent {
                hasExponent = true
                index += 1

                if !isAtEnd &&
                    (characters[index] == "+" ||
                     characters[index] == "-") {
                    index += 1
                }

                continue
            }

            break
        }

        guard start != index else {
            throw SVGPathParserError.missingNumber
        }

        let string = String(
            characters[start..<index]
        )

        guard let value = Double(string) else {
            throw SVGPathParserError.unexpectedToken(
                string
            )
        }

        return CGFloat(value)
    }
}
