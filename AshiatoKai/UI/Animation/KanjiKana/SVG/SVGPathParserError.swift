//
//  SVGPathParserError.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 02/10/26.
//

import Foundation

enum SVGPathParserError: Error {
    case unexpectedToken(String)
    case missingNumber
    case unsupportedCommand(Character)
}
