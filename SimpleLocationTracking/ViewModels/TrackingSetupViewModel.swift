//
//  TrackingSetupViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 1/20/24.
//

import Foundation
import CoreLocation
import Combine

class TrackingSetupViewModel {
    var locationManager: LocationManager?
    let settingManager = SettingManager.shared
    var subscriptions = Set<AnyCancellable>()
    @Published var status: CLAuthorizationStatus?

    func bind() {
        locationManager?.$authorizationStatus
            .sink { [weak self] status in
                self?.status = status
            }.store(in: &subscriptions)
    }

    func goTrackingButtonTapped(status: CLAuthorizationStatus, authorized: () -> Void, denied: () -> Void) {
        switch status {
        case .notDetermined:
            locationManager?.requestAuthorization()
        case .restricted, .denied:
            denied()
        case .authorizedAlways, .authorizedWhenInUse:
            authorized()
        default:
            break
        }
    }
}
