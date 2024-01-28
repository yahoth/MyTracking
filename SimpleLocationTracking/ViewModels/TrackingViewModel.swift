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
    private let stopwatch = Stopwatch()
    private var subscriptions = Set<AnyCancellable>()
    var startDate: Date?

    var speedInfos: [SpeedInfo] {
        [
            SpeedInfo(value: locationManager.averageSpeed, unit: unitOfSpeed?.displayedSpeedUnit, title: "Average Speed"),
            SpeedInfo(value: locationManager.topSpeed, unit: unitOfSpeed?.displayedSpeedUnit, title: "Top Speed"),
            SpeedInfo(value: locationManager.distance, unit: unitOfSpeed?.correspondingDistanceUnit, title: "Distance"),
            SpeedInfo(value: locationManager.currentAltitude, unit: unitOfSpeed?.correspondingAltitudeUnit, title: "Current Altitude"),
        ]
    }

    func createTrackingResult() async -> TrackingData {

        let speedInfos = [
            SpeedInfo(value: locationManager.distance, unit: unitOfSpeed?.correspondingDistanceUnit, title: "Distance"),
            SpeedInfo(value: totalElapsedTime, unit: nil, title: "Time"),
            SpeedInfo(value: locationManager.averageSpeed, unit: unitOfSpeed?.displayedSpeedUnit, title: "Average Speed"),
            SpeedInfo(value: locationManager.topSpeed, unit: unitOfSpeed?.displayedSpeedUnit, title: "Top Speed"),
            SpeedInfo(value: locationManager.currentAltitude, unit: unitOfSpeed?.correspondingAltitudeUnit, title: "Altitude"),
            SpeedInfo(value: floor, unit: "floor", title: "Floor")
        ]

        let startLocation = await locationManager.reverseGeocodeLocation(startCoordinate)

        let endLocation = await locationManager.reverseGeocodeLocation(endCoordinate)

        let trackingData = TrackingData(speedInfos: speedInfos.toRealmList(), pathInfos: locationManager.path.toRealmList(), startDate: startDate ?? Date(), endDate: Date(), startLocation: startLocation, endLocation: endLocation)
        DispatchQueue.main.async {
            RealmManager.shared.create(object: trackingData)
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

    var convertedSpeed: Double {
        locationManager.speed.speedToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var convertedDistance: Double {
        locationManager.distance.distanceToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var convertedTopSpeed: Double {
        locationManager.topSpeed.speedToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var convertedAverageSpeed: Double {
        locationManager.averageSpeed.speedToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var convertedCurrentAltitude: Double {
        locationManager.currentAltitude.altitudeToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var convertedAltitude: Double {
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
        stopwatch.pause()
        isPaused = true
        isStopped = true
    }

//   func calculateDistance() -> CLLocationDistance {
//        let totalDistance = averageSpeed * Double(stopwatch.count) / 3600
//       print("distance: \(distance)")
//       print("calculat: \(totalDistance)")
//       return totalDistance
//    }
}
