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
    @Persisted var coordinate: CLLocationCoordinate2D
    @Persisted var speed: Double

    convenience init(coordinate: CLLocationCoordinate2D, speed: Double) {
        self.init()
        self.coordinate = coordinate
        self.speed = speed
    }
}
