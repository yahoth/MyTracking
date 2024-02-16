//
//  ActivityType.swift
//  SimpleSpeedometer
//
//  Created by TAEHYOUNG KIM on 10/27/23.
//

import Foundation

import RealmSwift

enum ActivicyType: String, CaseIterable, PersistableEnum {
    case automobile
    case offroad_vehicle = "Off-road Vehicle"
    case running
    case walking
    case hiking
    case cycling
    case train
    case airplane

    var image: String {
        switch self {
        case .automobile:
            return "car"
        case .offroad_vehicle:
            return "jeep"
        case .running:
            return "running"
        case .walking:
            return "walking"
        case .hiking:
            return "hiking"
        case .cycling:
            return "cycling"
        case .train:
            return "train"
        case .airplane:
            return "airplane"
        }
    }
}
