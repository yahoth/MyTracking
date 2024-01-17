//
//  TrackingViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/29/23.
//

import Foundation
import Combine
import CoreLocation

import FloatingPanel
import RealmSwift

final class TrackingViewModel {

    deinit {
        print("TrackingViewModel deinit")
    }

    private let locationManager = LocationManager()
    private let settingManager = SettingManager()
    private let realmManager = RealmManager()
    private let stopwatch = Stopwatch()
    private var subscriptions = Set<AnyCancellable>()
    var startDate: Date?

    var speedInfos: [SpeedInfo] {
        [
            SpeedInfo(value: averageSpeed, unit: "km/h", title: "Average Speed"),
            SpeedInfo(value: topSpeed, unit: "km/h", title: "Top Speed"),
            SpeedInfo(value: distance, unit: "km", title: "Distance"),
            SpeedInfo(value: currentAltitude, unit: "m", title: "Current Altitude"),
        ]
    }

    func createTrackingResult() async -> TrackingData {

        let speedInfos = [
            SpeedInfo(value: distance, unit: "km", title: "Distance"),
            SpeedInfo(value: totalElapsedTime, unit: nil, title: "Time"),
            SpeedInfo(value: averageSpeed, unit: "km/h", title: "Average Speed"),
            SpeedInfo(value: topSpeed, unit: "km/h", title: "Top Speed"),
            SpeedInfo(value: altitude, unit: "m", title: "Altitude"),
            SpeedInfo(value: floor, unit: "floor", title: "Floor")
        ]

        let startLocation = await locationManager.reverseGeocodeLocation(startCoordinate)

        let endLocation = await locationManager.reverseGeocodeLocation(endCoordinate)

        let trackingData = TrackingData(speedInfos: speedInfos.toRealmList(), pathInfos: locationManager.path.toRealmList(), startDate: startDate ?? Date(), endDate: Date(), startLocation: startLocation, endLocation: endLocation)
        DispatchQueue.main.async { [weak self] in
            self?.realmManager.create(object: trackingData)
        }

        return trackingData
    }


    @Published var state: FloatingPanelState
    weak var fpc: FloatingPanelController?

    init(fpc: FloatingPanelController) {
        self.state = fpc.state
        self.fpc = fpc
        bind()
    }

    var floor: Double {
        Double(locationManager.floor)
    }

    var speed: Double {
        locationManager.speed.speedToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var distance: Double {
        locationManager.distance.distanceToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var topSpeed: Double {
        locationManager.topSpeed.speedToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var averageSpeed: Double {
        locationManager.averageSpeed.speedToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var currentAltitude: Double {
        locationManager.currentAltitude.altitudeToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var altitude: Double {
        locationManager.altitude.altitudeToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var coordinates: [CLLocationCoordinate2D] {
        locationManager.path.map { $0.coordinate }
    }

    var startCoordinate: CLLocationCoordinate2D {
        coordinates.first ?? CLLocationCoordinate2D()
    }

    var endCoordinate: CLLocationCoordinate2D {
        coordinates.last ?? CLLocationCoordinate2D()
    }

    @Published var isPaused: Bool = true
    @Published var isStopped: Bool = false
    @Published var unitOfSpeed: UnitOfSpeed?
    @Published var isLocationDisable = false
    @Published var totalElapsedTime: Double = 0

    var hhmmss: String {
        totalElapsedTime.hhmmss
    }

    var resultTime: String {
        totalElapsedTime.resultTime
    }

    var points: [CLLocationCoordinate2D]? {
        locationManager.points
    }

    private func bind() {
        stopwatch.$count
            .sink { [weak self] count in
                self?.totalElapsedTime = count
            }.store(in: &subscriptions)

        settingManager.$unit
            .sink { [weak self] unit in
                self?.unitOfSpeed = unit
            }.store(in: &subscriptions)
    }


    func updateUnit(_ unit: UnitOfSpeed) {
        settingManager.updateUnit(unit)
    }

    func startAndPause() {
        if isPaused {
            locationManager.start()
            stopwatch.start()
            isPaused = false
            isStopped = false
            if startDate == nil {
                startDate = Date()
            }
        } else {
            locationManager.stop()
            stopwatch.pause()
            isPaused = true
        }
    }

    func stop() {
        locationManager.stop()
//        stopwatch.stop()
//        locationManager.speed = 0
//        locationManager.speeds = []
//        locationManager.altitude = 0
//        locationManager.distance = 0
//        locationManager.topSpeed = 0
//        locationManager.averageSpeed = 0
//        locationManager.currentAltitude = 0
//        locationManager.coordinates = []
        stopwatch.pause()
        isPaused = true
        isStopped = true
    }

    func locationManagerDidChangeAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:  // Location services are available.
            startAndPause()
            break

        case .restricted, .denied:  // Location services currently unavailable.
            isLocationDisable = true
            break

        case .notDetermined:        // Authorization not determined yet.
            locationManager.requestAuthorization()
            break

        default:
            break
        }
    }

//   func calculateDistance() -> CLLocationDistance {
//        let totalDistance = averageSpeed * Double(stopwatch.count) / 3600
//       print("distance: \(distance)")
//       print("calculat: \(totalDistance)")
//       return totalDistance
//    }
}
