//
//  GeographicProjection.swift
//  AshiatoKai
//
//  Created by Max Ueda on 04/10/26.
//

import CoreGraphics

struct GeographicProjection {

    private let bounds: GeographicBounds
    private let size: CGSize

    private let padding: CGFloat = 20

    init(
        bounds: GeographicBounds,
        size: CGSize
    ) {
        self.bounds = bounds
        self.size = size
    }

    private var referenceLatitudeRadians: Double {
        let latitude =
            (
                bounds.minimumLatitude
                + bounds.maximumLatitude
            ) / 2

        return latitude * .pi / 180
    }

    func point(
        for coordinate: GeographicCoordinate
    ) -> CGPoint {
        let longitudeRange =
            bounds.maximumLongitude
            - bounds.minimumLongitude

        let latitudeRange =
            bounds.maximumLatitude
            - bounds.minimumLatitude

        guard longitudeRange > 0,
              latitudeRange > 0 else {
            return CGPoint(
                x: size.width / 2,
                y: size.height / 2
            )
        }

        let availableWidth =
            max(size.width - padding * 2, 1)

        let availableHeight =
            max(size.height - padding * 2, 1)

        // At Japan's latitude, one degree of longitude represents
        // less physical distance than one degree of latitude.
        // Correcting longitude by cos(reference latitude) prevents
        // the geometry from being stretched horizontally.
        
        let longitudeScale =
            cos(referenceLatitudeRadians)

        let projectedWidth =
            longitudeRange * longitudeScale

        let projectedHeight =
            latitudeRange

        let scale = min(
            availableWidth / projectedWidth,
            availableHeight / projectedHeight
        )

        let renderedWidth =
            projectedWidth * scale

        let renderedHeight =
            projectedHeight * scale

        let xOffset =
            (size.width - renderedWidth) / 2

        let yOffset =
            (size.height - renderedHeight) / 2

        let x =
            xOffset
            + (
                coordinate.longitude
                - bounds.minimumLongitude
            )
            * longitudeScale
            * scale

        // Geographic latitude increases upwards,
        // whereas SwiftUI's Y axis increases downwards.
        let y =
            yOffset
            + (
                bounds.maximumLatitude
                - coordinate.latitude
            ) * scale

        return CGPoint(
            x: x,
            y: y
        )
    }
}
