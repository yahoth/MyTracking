//
//  Double + Unit.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/12/23.
//

import UIKit
import CoreLocation

extension Double {

    func speedToSelectedUnit(_ unit: UnitOfSpeed) -> CLLocationSpeed {
        return self * unit.speedConversionFactor
    }

    func distanceToSelectedUnit(_ unit: UnitOfSpeed) -> CLLocationDistance {
        return self / unit.distanceConversionFactor
    }

    func altitudeToSelectedUnit(_ unit: UnitOfSpeed) -> Double {
        switch unit {
        case .kmh, .knot:
            return self
        case .mph, .fts:
            return self / 0.3048
        }
    }
}
