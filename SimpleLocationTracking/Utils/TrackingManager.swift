//
//  TrackingManager.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 2/23/24.
//

import Foundation
import CoreLocation

class TrackingManager {
    private struct Hello {
        var locations: [CLLocation]
        var speeds: [Double]
        init(locations: [CLLocation] = [], speeds: [Double] = []) {
            self.locations = locations
            self.speeds = speeds
        }
    }

    private var hello = Hello()


    // Location Data
    var currentAltitude: Double {
        hello.locations.last?.altitude ?? 0
    }

    var locations: [CLLocation] {
        hello.locations
    }

    var timedLocationDatas: [TimedLocationData] {
        hello.locations.map { TimedLocationData(coordinate: $0.coordinate, date: $0.timestamp, altitude: $0.altitude) }
    }

    var distance = 0.0
    var altitude = 0.0

    var points: [CLLocationCoordinate2D]?

    // Speed Data
    var speeds: [Double] {
        hello.speeds
    }

    var speed: Double {
        hello.speeds.last ?? 0
    }

    var topSpeed: Double {
        hello.speeds.max() ?? 0
    }

    var averageSpeed: Double {
        hello.speeds.reduce(0, +) / Double(hello.speeds.count)
    }

    func addLocationAndSpeed(_ newLocation: CLLocation) {
        let now = Date()
        let locationAge = now.timeIntervalSince(newLocation.timestamp)
        guard locationAge < 60 else { return }

        if isNewLocationUsable(newLocation) {
            let previousLocation = hello.locations.last

            if let previousLocation {
                if Date().timeIntervalSince(previousLocation.timestamp) < 60 {
                    points = [ previousLocation.coordinate, newLocation.coordinate ]
                    distance += newLocation.distance(from: previousLocation)
                    altitude += newLocation.altitude - previousLocation.altitude > 0  ? newLocation.altitude - previousLocation.altitude : 0
                }
            }

            print("good work")
            hello.locations.append(newLocation)

        }

        if isNewSpeedUsable(newLocation) {
            hello.speeds.append(newLocation.speed)
        }
    }

    private func isNewLocationUsable(_ newLocation: CLLocation) -> Bool {
        guard hello.locations.count > 5 else { return true }
        let minimumDistanceBetweenLocationsInMeters = 10.0
        let previousLocation = hello.locations.last!
        let metersApart = newLocation.distance(from: previousLocation)
        return metersApart > minimumDistanceBetweenLocationsInMeters
    }

    private func isNewSpeedUsable(_ newLocation: CLLocation) -> Bool {
        guard newLocation.speedAccuracy >= 0 else { return false }
        guard hello.speeds.count > 10 else { return true }
        return true
    }

}
