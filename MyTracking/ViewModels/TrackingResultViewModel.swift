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
        guard let start = locationDatas.first?.coordinate else { return CLLocationCoordinate2D() }
        return start
    }

    var end: CLLocationCoordinate2D {
        guard let start = locationDatas.last?.coordinate else { return CLLocationCoordinate2D() }
        return start
    }

    var locationDatas: [LocationDataPerTenMeters] {
        Array(path.locationDatas)
    }

    var speeds: [CLLocationSpeed] {
        Array(path.speedsAndAltitudes.map { $0.speed })
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
}
