//
//  TrackingViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/29/23.
//

import UIKit
import Combine
import CoreLocation

import FloatingPanel
import RealmSwift

final class TrackingViewModel {

    deinit {
        print("TrackingViewModel deinit")
        locationManager.trackingManager = nil
    }

    let locationManager = LocationManager.shared
    private let settingManager = SettingManager.shared
    private let stopwatch = Stopwatch()
    private var subscriptions = Set<AnyCancellable>()
    private var startDate: Date?
    var endDate: Date?

    var bottomSafeArea: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0}
        guard let window = windowScene.windows.first else { return 0}
        guard let root = window.rootViewController else { return 0}
        return root.view.safeAreaInsets.bottom
    }
    
    var workItem: DispatchWorkItem?
    var isFirstCall = true

    var navigationBarHeight: CGFloat = 0

    var mapViewBottomPadding: CGFloat {
        navigationBarHeight + bottomSafeArea
    }

    var speedInfos: [SpeedInfo] {
        [
            SpeedInfo(value: locationManager.trackingManager?.averageSpeed ?? 0, unit: unitOfSpeed?.displayedSpeedUnit, title: "Average Speed"),
            SpeedInfo(value: locationManager.trackingManager?.topSpeed ?? 0, unit: unitOfSpeed?.displayedSpeedUnit, title: "Top Speed"),
            SpeedInfo(value: locationManager.trackingManager?.totalDistance ?? 0, unit: unitOfSpeed?.correspondingDistanceUnit, title: "Distance"),
            SpeedInfo(value: locationManager.trackingManager?.altitude ?? 0, unit: unitOfSpeed?.correspondingAltitudeUnit, title: "Current Altitude"),
        ]
    }

    @MainActor
    func createTrackingResult() async -> TrackingData {

        let speedInfos = [
            SpeedInfo(value: locationManager.trackingManager?.totalDistance ?? 0, unit: unitOfSpeed?.correspondingDistanceUnit, title: "Distance"),
            SpeedInfo(value: endDate?.timeIntervalSince(startDate ?? Date()) ?? totalElapsedTime, unit: nil, title: "Time"),
            SpeedInfo(value: locationManager.trackingManager?.averageSpeed ?? 0, unit: unitOfSpeed?.displayedSpeedUnit, title: "Average Speed"),
            SpeedInfo(value: locationManager.trackingManager?.topSpeed ?? 0, unit: unitOfSpeed?.displayedSpeedUnit, title: "Top Speed"),
            SpeedInfo(value: locationManager.trackingManager?.totalAltitude ?? 0, unit: unitOfSpeed?.correspondingAltitudeUnit, title: "Altitude"),
        ]

        let locationDatas = locationManager.trackingManager?.locationData ?? []

        let startLocation = await locationManager.reverseGeocodeLocation(locationDatas.first?.coordinate ?? CLLocationCoordinate2D())

        let endLocation = await locationManager.reverseGeocodeLocation(locationDatas.last?.coordinate ?? CLLocationCoordinate2D())
        let speeds = locationManager.trackingManager?.speeds ?? []
        let pathInfo = PathInfo(locationDatas: locationDatas, speedsAndAltitudes: speeds)

        let trackingData = TrackingData(speedInfos: speedInfos.toRealmList(), pathInfo: pathInfo, startDate: startDate ?? Date(), endDate: endDate ?? Date(), startLocation: startLocation, endLocation: endLocation, activityType: settingManager.activityType)

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
        locationManager.trackingManager = TrackingManager()
        bind()
    }

    var convertedSpeed: Double {
        locationManager.trackingManager?.speed.speedToSelectedUnit(unitOfSpeed ?? .kmh) ?? 0
    }

    @Published var isPaused: Bool = true
    @Published var isStopped: Bool = false
    @Published var unitOfSpeed: UnitOfSpeed?
    @Published var totalElapsedTime: Double = 0

    var points: [CLLocationCoordinate2D]? {
        locationManager.trackingManager?.points
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
