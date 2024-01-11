//
//  TrackingData.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/29/23.
//

import Foundation

struct TrackingData {
    let speedInfos: [SpeedInfo]
    let pathInfos: [PathInfo]
    let startDate: Date
    let endDate: Date
    var startLocation: String?
    var endLocation: String?
    var tripType: TripType = .oneWay
}
