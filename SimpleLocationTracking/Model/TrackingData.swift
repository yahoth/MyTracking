//
//  TrackingData.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/29/23.
//

import Foundation

import RealmSwift

class TrackingData: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var speedInfos: List<SpeedInfo>
    @Persisted var pathInfos: List<PathInfo>
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var startLocation: String?
    @Persisted var endLocation: String?
    @Persisted var tripType: TripType = .oneWay

    convenience init(speedInfos: List<SpeedInfo>, pathInfos: List<PathInfo>, startDate: Date, endDate: Date, startLocation: String?, endLocation: String?, tripType: TripType = .oneWay
    ) {
        self.init()
        self.speedInfos = speedInfos
        self.pathInfos = pathInfos
        self.startDate = startDate
        self.endDate = endDate
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.tripType = tripType
    }
}

extension TrackingData {
    private var dateComponent: DateComponents {
        Calendar(identifier: .gregorian).dateComponents([.year, .month], from: startDate)
    }

    var monthlyIdentifier: String {
        return "\(dateComponent.year!)-\(dateComponent.month!)"
    }
}
