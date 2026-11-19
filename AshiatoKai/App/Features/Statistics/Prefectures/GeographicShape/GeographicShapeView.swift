//
//  GeographicShapeView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import SwiftUI

struct GeographicShapeView: View {

    let geolocation: Geolocation

    var body: some View {
        GeometryReader { proxy in
            let projection = GeographicProjection(
                bounds:
                    geolocation.displayBounds
                    ?? geolocation.bounds,
                size: proxy.size
            )

            ZStack {
                geographicShape(
                    projection: projection
                )

                if let capital = geolocation.capital {
                    capitalMarker(
                        capital,
                        projection: projection
                    )
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private func geographicShape(
        projection: GeographicProjection
    ) -> some View {
        Canvas { context, _ in
            let path = makePath(
                geometry: geolocation.geometry,
                projection: projection
            )

            context.fill(
                path,
                with: .foreground,
                style: FillStyle(eoFill: true)
            )

            context.stroke(
                path,
                with: .foreground,
                lineWidth: 2
            )
        }
        .foregroundStyle(.secondary.opacity(0.22))
        .overlay {
            Canvas { context, _ in
                let path = makePath(
                    geometry: geolocation.geometry,
                    projection: projection
                )

                context.stroke(
                    path,
                    with: .foreground,
                    lineWidth: 2
                )
            }
            .foregroundStyle(.primary)
        }
    }

    private func capitalMarker(
        _ capital: GeographicCapital,
        projection: GeographicProjection
    ) -> some View {
        let point = projection.point(
            for: capital.coordinate
        )

        return ZStack {
            Circle()
                .fill(.background)
                .frame(width: 16, height: 16)

            Circle()
                .fill(.red)
                .frame(width: 10, height: 10)
        }
        .position(point)
        .accessibilityLabel(
            Text("statistics.capital_accessibility \(capital.name)")
        )
    }

    private func makePath(
        geometry: GeographicGeometry,
        projection: GeographicProjection
    ) -> Path {
        var path = Path()

        switch geometry {
        case .polygon(let rings):
            append(
                rings: rings,
                to: &path,
                projection: projection
            )

        case .multiPolygon(let polygons):
            for polygon in polygons {
                append(
                    rings: polygon,
                    to: &path,
                    projection: projection
                )
            }
        }

        return path
    }

    private func append(
        rings: [[GeographicCoordinate]],
        to path: inout Path,
        projection: GeographicProjection
    ) {
        for ring in rings {
            guard let first = ring.first else {
                continue
            }

            path.move(
                to: projection.point(for: first)
            )

            for coordinate in ring.dropFirst() {
                path.addLine(
                    to: projection.point(
                        for: coordinate
                    )
                )
            }

            path.closeSubpath()
        }
    }
}
