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
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 0.7
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

    func reverseGeocodeLocation(_ coordinate: CLLocationCoordinate2D, maxAttempts: Int = 3, currentAttempt: Int = 0) async -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        do {
            let placemark = try await geocoder.reverseGeocodeLocation(location).first

            let result = "\(placemark?.locality ?? String()) \(placemark?.subLocality ?? String())"

            if result.trimmingCharacters(in: .whitespaces).count > 0 {
                return result
            } else {
                return "lat: \(coordinate.latitude), long: \(coordinate.longitude)"
            }
        } catch let error {
            if let error = error as NSError? {
                if error.code == CLError.network.rawValue && currentAttempt < maxAttempts {
                    return await self.reverseGeocodeLocation(coordinate, maxAttempts: maxAttempts, currentAttempt: currentAttempt + 1)
                } else {
                    print(error.localizedDescription)
                    return "title"
                }
            }
        }
    }

}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.floor += (location.floor?.level ?? 0)
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

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("*****didFailWithError, \(error.localizedDescription)*****")
    }

    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        print("*****didFailRangingFor, \(error.localizedDescription)*****")
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("*****monitoringDidFailFor, \(error.localizedDescription)*****")
    }

    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("*****didFinishDeferredUpdatesWithError, \(String(describing: error?.localizedDescription))*****")
    }
}
