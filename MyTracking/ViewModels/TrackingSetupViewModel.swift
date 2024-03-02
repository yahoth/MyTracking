//
//  TrackingSetupViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 1/20/24.
//

import UIKit
import CoreLocation
import Combine

class TrackingSetupViewModel {
    let locationManager = LocationManager.shared
    let settingManager = SettingManager.shared
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
}
