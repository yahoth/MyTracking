//
//  UnitOfSpeed.swift
//  SimpleSpeedometer
//
//  Created by TAEHYOUNG KIM on 10/13/23.
//

import Foundation
import CoreLocation

enum UnitOfSpeed: String, CaseIterable {

    case kmh   // kilometer per hour (km/h)
    case mph   // miles per hour (mph or mi/h)
    case knot  // knot (kt or kn)
    case fts   // feet per second (ft/s)


    var speedConversionFactor: Double {
           switch self {
           case .kmh:
               return 3.6
           case .mph:
               return 2.236_936
           case .knot:
               return 1.943_844
           case .fts:
               return 3.280_84
           }
       }

    var distanceConversionFactor: Double {
        switch self {
        case .kmh:
            return 1000
        case .mph:
            return 1609.344
        case .knot:
            return 1852
        case .fts:
            return 0.3048
        }
    }


    var displayedSpeedUnit: String {
        switch self {
        case .kmh:
            return "km/h"
        case .mph:
            return "mph"
        case .knot:
            return "kt"
        case .fts:
            return "ft/s"
        }
    }


    var correspondingDistanceUnit: String {
        switch self {
        case .kmh:
            return "km"
        case .mph:
            return "mi"
        case .knot:
            return "nm"
        case .fts:
            return "ft"
        }
    }

    var correspondingAltitudeUnit: String {
        switch self {
        case .kmh, .knot:
            return "m"
        case .mph, .fts:
            return "ft"
        }
    }
}

