//
//  LocationManager.swift
//  SimpleSpeedometer
//
//  Created by TAEHYOUNG KIM on 10/18/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {

    private let locationManager = CLLocationManager()

    @Published var speed: CLLocationSpeed = 0
    var speeds: [CLLocationSpeed] = []
    @Published var altitude: Double = 0
    @Published var currentAltitude: Double = 0
    @Published var authorizationStatus: CLAuthorizationStatus  = .notDetermined
    @Published var distance: CLLocationDistance = 0
    @Published var topSpeed: CLLocationSpeed = 0
    @Published var averageSpeed: CLLocationSpeed = 0
    @Published var rotation: Double = 0
    @Published var coordinates: [CLLocationCoordinate2D] = []
    @Published var points: [CLLocationCoordinate2D]?
    var previousLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.activityType = .otherNavigation
    }

    func start() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
        previousLocation = nil
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if location.speed >= 0 {
            speed = location.speed
            speeds.append(speed)
            averageSpeed = speeds.reduce(0, +) / Double(speeds.count)
            topSpeed = speeds.max() ?? 0
            let currentAltitude = location.altitude
            self.currentAltitude = currentAltitude
            coordinates.append(location.coordinate)

            if let previousLocation {
                distance += location.distance(from: previousLocation)
                if previousLocation.altitude < currentAltitude {
                    altitude += currentAltitude - previousLocation.altitude
                }
                let points = [previousLocation.coordinate, location.coordinate]
                self.points = points
            }
            
            previousLocation = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let rotation = -newHeading.trueHeading * Double.pi / 180
        self.rotation = rotation
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
