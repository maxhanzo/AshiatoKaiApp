//
//  AnimCJKParserError.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import Foundation

enum AnimCJKParserError: LocalizedError {
    case invalidSVG
    case xmlParsingFailed(String)
    case noStrokesFound(Character)
    case missingShapePath(String)
    case invalidShapePath(String)
    case invalidDrawingPath(String)

    var errorDescription: String? {
        switch self {
        case .invalidSVG:
            return "The AnimCJK SVG is invalid."

        case .xmlParsingFailed(let message):
            return "Unable to parse the AnimCJK SVG: \(message)"

        case .noStrokesFound(let character):
            return "No strokes were found for \(character)."

        case .missingShapePath(let identifier):
            return "The shape path \(identifier) could not be found."

        case .invalidShapePath(let identifier):
            return "The shape path \(identifier) is invalid."

        case .invalidDrawingPath(let identifier):
            return "The drawing path for \(identifier) is invalid."
        }
    }
}
