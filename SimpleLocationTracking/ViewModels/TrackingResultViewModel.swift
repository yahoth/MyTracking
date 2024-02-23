//
//  TrackingCompletionViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit
import CoreLocation

import RealmSwift

final class TrackingResultViewModel {
    deinit {
        print("TrackingResultViewModel deinit")
    }

    var speedInfos: List<SpeedInfo> {
        trackingData.speedInfos
    }

    var path: PathInfo {
        trackingData.pathInfo ?? PathInfo()
    }

    var start: CLLocationCoordinate2D {
        guard let start = coordinates.first?.coordinate else { return CLLocationCoordinate2D() }
        return start
    }

    var end: CLLocationCoordinate2D {
        guard let start = coordinates.last?.coordinate else { return CLLocationCoordinate2D() }
        return start
    }

    var coordinates: [TimedLocationData] {
        Array(path.coordinates)
    }

    var speeds: [CLLocationSpeed] {
        Array(path.speeds)
    }

    var trackingData: TrackingData

    enum ViewType {
        case modal
        case navigation
    }
    var viewType: ViewType?

    init(trackingData: TrackingData, viewType: ViewType) {
        self.trackingData = trackingData
        self.viewType = viewType
    }

    func reverseGeocodeLocation(_ coordinate: CLLocationCoordinate2D) async -> String {
        await LocationManager.shared.reverseGeocodeLocation(coordinate)
    }
}
