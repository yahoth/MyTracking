//
//  SpeedInfo.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/8/23.
//

import Foundation

struct SpeedInfo {
    let value: Any
    let unit: String?
    let title: String
}

extension SpeedInfo {
    static let mocks = [
        SpeedInfo(value: 10111111, unit: "km/h", title: "Average Speed"),
        SpeedInfo(value: 15, unit: "km/h", title: "Top Speed"),
        SpeedInfo(value: 0, unit: nil, title: "Time"),
        SpeedInfo(value: 12, unit: "m", title: "Altitude"),
        SpeedInfo(value: 12, unit: "m", title: "Current Altitude"),
        SpeedInfo(value: 1.5, unit: "km", title: "Distance"),
    ]
}
