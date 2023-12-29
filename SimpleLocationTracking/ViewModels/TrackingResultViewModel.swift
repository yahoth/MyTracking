//
//  TrackingCompletionViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit
import CoreLocation

final class TrackingResultViewModel {
    var speedInfos: [SpeedInfo] {
        trackingData.speedInfos
    }

    var path: [PathInfo] {
        trackingData.pathInfos
    }

    var start: CLLocationCoordinate2D {
        guard let start = coordinates.first else { return CLLocationCoordinate2D() }
        return start
    }

    var end: CLLocationCoordinate2D {
        guard let start = coordinates.last else { return CLLocationCoordinate2D() }
        return start
    }

    var coordinates: [CLLocationCoordinate2D] {
        path.map { $0.coordinate }
    }

    var speeds: [CLLocationSpeed] {
        path.map { $0.speed }
    }

    var trackingData: TrackingData

    init(trackingData: TrackingData) {
        self.trackingData = trackingData
    }

    func reverseGeocodeLocation(_ coordinate: CLLocationCoordinate2D) async throws -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let placemark = try await geocoder.reverseGeocodeLocation(location).first
        //간단한 주소
        let result = "\(placemark?.locality ?? String()) \(placemark?.subLocality ?? String())"

        if result.trimmingCharacters(in: .whitespaces).count > 0 {
            return result
        } else {
            return "lat: \(coordinate.latitude), long: \(coordinate.longitude)"
        }
    }
}
