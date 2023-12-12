//
//  ActivityType.swift
//  SimpleSpeedometer
//
//  Created by TAEHYOUNG KIM on 10/27/23.
//

import Foundation

enum ActivicyType: String, CaseIterable {
    case automobile // automotiveNavigation
    case running // fitness
    case walking // fitness
    case hiking // fitness
    case cycling // otherNavigation
    case train // otherNavigation
    case airplane // airborne

    var image: String {
        switch self {
        case .automobile:
            return "car"
        case .running:
            return "figure.run"
        case .walking:
            return "figure.walk"
        case .hiking:
            return "figure.hiking"
        case .cycling:
            return "figure.outdoor.cycle"
        case .train:
            return "train.side.front.car"
        case .airplane:
            return "airplane"
        }
    }
}
