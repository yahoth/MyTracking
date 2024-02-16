//
//  LocationManager.swift
//  SimpleSpeedometer
//
//  Created by TAEHYOUNG KIM on 10/18/23.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject {
    deinit {
        print("LocationManager deinit")
    }
    
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var subscriptions = Set<AnyCancellable>()

    @Published var speed: CLLocationSpeed = 0
    var speeds: [CLLocationSpeed] = []
    @Published var altitude: Double = 0
    @Published var currentAltitude: Double = 0
    @Published var authorizationStatus: CLAuthorizationStatus  = .notDetermined
    @Published var distance: CLLocationDistance = 0
    @Published var topSpeed: CLLocationSpeed = 0
    @Published var averageSpeed: CLLocationSpeed = 0
    @Published var coordinates: [CLLocationCoordinate2D] = []
    @Published var points: [CLLocationCoordinate2D]?
    var path: [PathInfo] = []
    var previousLocation: CLLocation?
    var floor: Int = 0

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        bind()
    }

    func bind() {
        SettingManager.shared.$activityType
            .sink { [weak self] type in
                guard let self else { return }
                self.update(type: type)
                print("accuracy: \(self.locationManager.desiredAccuracy), filter: \(self.locationManager.distanceFilter), type: \(self.locationManager.activityType)")
            }.store(in: &subscriptions)
    }

    func update(type: ActivicyType) {
        switch type {
        case .automobile:
            setup(accuracy: kCLLocationAccuracyBestForNavigation, type: .automotiveNavigation)
        case .train, .offroad_vehicle:
            setup(accuracy: kCLLocationAccuracyBestForNavigation, type: .otherNavigation)
        case .airplane:
            setup(accuracy: kCLLocationAccuracyBestForNavigation, type: .airborne)
        case .running, .walking, .hiking, .cycling:
            setup(accuracy: kCLLocationAccuracyBest, type: .otherNavigation)
        }

        func setup(accuracy: CLLocationAccuracy, type: CLActivityType) {
            locationManager.desiredAccuracy = accuracy
            locationManager.distanceFilter = 0.7
            locationManager.activityType = type
        }
    }

    func start() {
        locationManager.startUpdatingLocation()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }

    func reset() {
        speed = 0
        speeds = []
        altitude = 0
        currentAltitude = 0
        distance = 0
        topSpeed = 0
        averageSpeed = 0
        coordinates = []
        points = nil
        previousLocation = nil
        floor = 0
        path = []
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
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
                    return "lat: \(coordinate.latitude), long: \(coordinate.longitude)"
                }
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else { return }
        guard Date().timeIntervalSince(location.timestamp) < 1 else { return }

        print("speed: \(location.speed), HAccuracy: \(location.horizontalAccuracy), VAccuracy: \(location.verticalAccuracy)")
        guard location.speedAccuracy >= 0, location.horizontalAccuracy >= 0 else { return }

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

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("*****DidPauseLocationUpdates*****")
        print("time: \(Date())")
    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("*****DidResumeLocationUpdates*****")
        print("time: \(Date())")
    }
}
