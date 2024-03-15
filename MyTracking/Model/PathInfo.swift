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
    @Persisted var locationDatas: List<LocationDataPerTenMeters>
    @Persisted var speedsAndAltitudes: List<SpeedAndAltitudePerSeconds>

    convenience init(locationDatas: [LocationDataPerTenMeters], speedsAndAltitudes: [SpeedAndAltitudePerSeconds]) {
        self.init()
        self.locationDatas.append(objectsIn: locationDatas)
        self.speedsAndAltitudes.append(objectsIn: speedsAndAltitudes)
    }
}

class LocationDataPerTenMeters: Object {
    @Persisted var coordinate: CLLocationCoordinate2D
    @Persisted var date: Date

    convenience init(coordinate: CLLocationCoordinate2D, date: Date) {
        self.init()
        self.coordinate = coordinate
        self.date = date
    }
}

class SpeedAndAltitudePerSeconds: Object {
    @Persisted var speed: Double
    @Persisted var altitude: Double
    @Persisted var date: Date

   convenience init(speed: Double, altitude: Double, date: Date) {
       self.init()
        self.speed = speed
       self.altitude = altitude
        self.date = date
    }
}

extension SpeedAndAltitudePerSeconds {
}
