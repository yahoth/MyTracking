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
    var subscriptions = Set<AnyCancellable>()
    @Published var status: CLAuthorizationStatus?

    init() {
    }

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
            print("denied")
            denied()
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
            authorized()
        default:
            print("hello")
        }
    }
}
