//
//  TrackingCompletionViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit
import CoreLocation

final class TrackingResultViewModel {
    var speedInfos: [SpeedInfo]

    @Published var path: [PathInfo]

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

    init(speedInfos: [SpeedInfo], path: [PathInfo]) {
        self.speedInfos = speedInfos
        self.path = path
    }

    func reverseGeocodeLocation(_ coordinate: CLLocationCoordinate2D) async throws -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let placemark = try await geocoder.reverseGeocodeLocation(location).first
        let result = "\(placemark?.locality ?? "") \(placemark?.subLocality ?? "")"
        return result
    }
}
