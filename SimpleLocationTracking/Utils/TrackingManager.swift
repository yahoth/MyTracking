//
//  TrackingManager.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 2/23/24.
//

import Foundation
import CoreLocation

class TrackingManager {
    private struct LocationInfo {
        var locations: [CLLocation]
        var speedsAndAltitudes: [SpeedAndAltitudePerSeconds]
        init(locations: [CLLocation] = [], speedsAndAltitudes: [SpeedAndAltitudePerSeconds] = []) {
            self.locations = locations
            self.speedsAndAltitudes = speedsAndAltitudes
        }
    }

    private var locationInfo = LocationInfo()

    // Location Data
    var locations: [CLLocation] {
        locationInfo.locations
    }

    var locationData: [LocationDataPerTenMeters] {
        locationInfo.locations.map { LocationDataPerTenMeters(coordinate: $0.coordinate, date: $0.timestamp) }
    }

    var totalDistance = 0.0
    var totalAltitude = 0.0

    var points: [CLLocationCoordinate2D]?

    // Speed Data
    var speeds: [SpeedAndAltitudePerSeconds] {
        locationInfo.speedsAndAltitudes
    }

    var speed: Double {
        locationInfo.speedsAndAltitudes.last?.speed ?? 0
    }

    var topSpeed: Double {
        locationInfo.speedsAndAltitudes.map{ $0.speed }.max() ?? 0
    }

    var averageSpeed: Double {
        locationInfo.speedsAndAltitudes.map{ $0.speed }.reduce(0, +) / Double(locationInfo.speedsAndAltitudes.count)
    }

    var altitude: Double {
        locationInfo.speedsAndAltitudes.map{ $0.altitude }.last ?? 0
    }

    func addLocationAndSpeed(_ newLocation: CLLocation) {
        let now = Date()
        let locationAge = now.timeIntervalSince(newLocation.timestamp)
        guard locationAge < 60 else { return }

        if isNewLocationUsable(newLocation) {
            let previousLocation = locationInfo.locations.last

            if let previousLocation {
                if Date().timeIntervalSince(previousLocation.timestamp) < 60 {
                    points = [ previousLocation.coordinate, newLocation.coordinate ]
                    totalDistance += newLocation.distance(from: previousLocation)
                    totalAltitude += newLocation.altitude - previousLocation.altitude > 0  ? newLocation.altitude - previousLocation.altitude : 0
                }
            }
            locationInfo.locations.append(newLocation)
        }

        if isNewSpeedUsable(newLocation) {
            locationInfo.speedsAndAltitudes.append(SpeedAndAltitudePerSeconds(speed: newLocation.speed, altitude: newLocation.altitude, date: newLocation.timestamp))
        }
    }

    private func isNewLocationUsable(_ newLocation: CLLocation) -> Bool {
        guard locationInfo.locations.count > 5 else { return true }
        let minimumDistanceBetweenLocationsInMeters = 10.0
        let previousLocation = locationInfo.locations.last!
        let metersApart = newLocation.distance(from: previousLocation)
        return metersApart > minimumDistanceBetweenLocationsInMeters
    }

    private func isNewSpeedUsable(_ newLocation: CLLocation) -> Bool {
        guard newLocation.speedAccuracy >= 0 else { return false }
        guard locationInfo.speedsAndAltitudes.count > 10 else { return true }
        return true
    }
}
