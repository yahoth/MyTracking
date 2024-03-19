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
    @Persisted var pathInfo: PathInfo?
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var startLocation: String?
    @Persisted var endLocation: String?
    @Persisted var tripType: TripType = .oneWay
    @Persisted var activityType: ActivicyType
    @Persisted var isDelete = false

    convenience init(speedInfos: List<SpeedInfo>, pathInfo: PathInfo, startDate: Date, endDate: Date, startLocation: String?, endLocation: String?, tripType: TripType = .oneWay, activityType: ActivicyType
    ) {
        self.init()
        self.speedInfos = speedInfos
        self.pathInfo = pathInfo
        self.startDate = startDate
        self.endDate = endDate
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.tripType = tripType
        self.activityType = activityType
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
