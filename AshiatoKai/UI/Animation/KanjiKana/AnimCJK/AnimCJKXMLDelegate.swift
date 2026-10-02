//
//  AnimCJKXMLDelegate.swift
//  AshiatoKai
//
//  Created by Max Ueda on 02/10/26.
//

import CoreGraphics
import Foundation

// MARK: - XML

final class AnimCJKXMLDelegate:
    NSObject,
    XMLParserDelegate {

    struct DrawingPath {
        let shapeIdentifier: String
        let strokeOrder: Int
        let pathData: String
    }

    private(set) var shapePaths:
        [String: String] = [:]

    private(set) var drawingPaths:
        [DrawingPath] = []

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict:
            [String: String]
    ) {
        guard elementName == "path",
              let pathData = attributeDict["d"]
        else {
            return
        }

        if let identifier = attributeDict["id"],
           isShapeIdentifier(identifier) {
            shapePaths[identifier] = pathData
            return
        }

        guard
            let clipPath = attributeDict["clip-path"],
            let shapeIdentifier =
                shapeIdentifier(from: clipPath),
            let style = attributeDict["style"],
            let strokeOrder =
                strokeOrder(from: style)
        else {
            return
        }

        drawingPaths.append(
            DrawingPath(
                shapeIdentifier: shapeIdentifier,
                strokeOrder: strokeOrder,
                pathData: pathData
            )
        )
    }

    private func isShapeIdentifier(
        _ identifier: String
    ) -> Bool {
        identifier.range(
            of: #"d\d+[a-z]?$"#,
            options: .regularExpression
        ) != nil
    }

    private func shapeIdentifier(
        from clipPath: String
    ) -> String? {
        // Example:
        // url(#z19978c1)
        //
        // The corresponding shape is:
        // z19978d1

        guard clipPath.hasPrefix("url(#"),
              clipPath.hasSuffix(")")
        else {
            return nil
        }

        let start = clipPath.index(
            clipPath.startIndex,
            offsetBy: 5
        )

        let end = clipPath.index(
            before: clipPath.endIndex
        )

        let clipIdentifier = String(
            clipPath[start..<end]
        )

        guard let cIndex =
                clipIdentifier.lastIndex(of: "c")
        else {
            return nil
        }

        var shapeIdentifier = clipIdentifier
        shapeIdentifier.replaceSubrange(
            cIndex...cIndex,
            with: "d"
        )

        return shapeIdentifier
    }

    private func strokeOrder(
        from style: String
    ) -> Int? {
        // Examples:
        // --d:1s;
        // --d:3s;

        guard let range = style.range(
            of: #"--d:\s*(\d+)s"#,
            options: .regularExpression
        ) else {
            return nil
        }

        let match = String(style[range])

        let digits = match.filter(\.isNumber)

        return Int(digits)
    }
}
