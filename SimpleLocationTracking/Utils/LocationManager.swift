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
    var path: [PathInfo] = []
    var previousLocation: CLLocation?
    var floor: Int = 0
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

    func speed(_ speed: Double) -> Double {
        return max(speed, 0)
    }

    func reverseGeocodeLocation(_ coordinate: CLLocationCoordinate2D) async throws -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let placemark = try await geocoder.reverseGeocodeLocation(location).first
        let result = (placemark?.locality ?? "") + (placemark?.subLocality ?? "")
        return result
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
//        self.path.append(location)

        if previousLocation?.floor?.level ?? 0 < location.floor?.level ?? 0 {
            self.floor += (location.floor?.level ?? 0) - (previousLocation?.floor?.level ?? 0)
        }

        self.speed = speed(location.speed)
        self.speeds.append(speed(location.speed))
        self.averageSpeed = self.speeds.reduce(0, +) / Double(self.speeds.count)
        self.topSpeed = self.speeds.max() ?? 0
        self.currentAltitude = location.altitude
        self.coordinates.append(location.coordinate)

        self.path.append(PathInfo(coordinate: location.coordinate, speed: speed(location.speed)))

        if let previousLocation {
            self.distance += location.distance(from: previousLocation)
            if previousLocation.altitude < self.currentAltitude {
                altitude += currentAltitude - previousLocation.altitude
            }
            let points = [previousLocation.coordinate, location.coordinate]
            self.points = points
        }

        previousLocation = location

    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let rotation = -newHeading.trueHeading * Double.pi / 180
        self.rotation = rotation
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
