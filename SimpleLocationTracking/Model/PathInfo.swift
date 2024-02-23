//
//  PathInfo.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/20/23.
//

import Foundation
import CoreLocation

import RealmSwift

class PathInfo: Object {
    @Persisted var coordinates: List<TimedLocationData>
    @Persisted var speeds: List<Double>

    convenience init(coordinates: [TimedLocationData], speeds: [Double]) {
        self.init()
        self.coordinates.append(objectsIn: coordinates)
        self.speeds.append(objectsIn: speeds)
    }
}

class TimedLocationData: Object {
    @Persisted var coordinate: CLLocationCoordinate2D
    @Persisted var date: Date
    @Persisted var altitude: Double

    convenience init(coordinate: CLLocationCoordinate2D, date: Date, altitude: Double) {
        self.init()
        self.coordinate = coordinate
        self.date = date
        self.altitude = altitude
    }
}
