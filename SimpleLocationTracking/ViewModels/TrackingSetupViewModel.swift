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
    let locationManager = LocationManager()
    var subscriptions = Set<AnyCancellable>()
    @Published var status: CLAuthorizationStatus?

    init() {
        bind()
    }

    func bind() {
        locationManager.$authorizationStatus
            .sink { [weak self] status in
                self?.status = status
            }.store(in: &subscriptions)
    }

    func request(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAuthorization()
        case .restricted, .denied:
            print("denied")
            // alert present
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
            // present modal
        @unknown default:
            fatalError()
        }
    }

    func goTrackingButtonTapped(authorized: () -> Void, denied: () -> Void) {
        switch status {
        case .notDetermined:
            locationManager.requestAuthorization()
        case .restricted, .denied:
            print("denied")
            denied()
            // alert present
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
            authorized()
            // present modal
        default:
            print("hello")
        }
    }
}
