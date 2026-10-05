//
//  PrefectureMapView.swift
//  AshiatoKai
//
//  Created by Max Hiroyuki Ueda on 04/10/26.
//

import MapKit
import SwiftUI

struct PrefectureMapView: View {

    let statistic: PrefectureStatistics
    let prefecture: JapanesePlace

    @State private var position: MapCameraPosition

    init(
        statistic: PrefectureStatistics,
        prefecture: JapanesePlace
    ) {
        self.statistic = statistic
        self.prefecture = prefecture

        _position = State(
            initialValue: .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: prefecture.latitude,
                        longitude: prefecture.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 2,
                        longitudeDelta: 2
                    )
                )
            )
        )
    }

    var body: some View {
        Map(position: $position) {
            Marker(
                prefecture.displayName,
                coordinate: CLLocationCoordinate2D(
                    latitude: prefecture.latitude,
                    longitude: prefecture.longitude
                )
            )
        }
        .navigationTitle(prefecture.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
