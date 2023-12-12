//
//  SettingManager.swift
//  SimpleSpeedometer
//
//  Created by TAEHYOUNG KIM on 10/18/23.
//

import Foundation

class SettingManager {
    private let defaults = UserDefaults.standard

    @Published var unit: UnitOfSpeed
    @Published var activityType: ActivicyType

    init() {
        let unit = defaults.string(forKey: "unitOfSpeed")!
        self.unit =  UnitOfSpeed(rawValue: unit) ?? .kmh

        let activityType = defaults.string(forKey: "activityType")!
        self.activityType = ActivicyType(rawValue: activityType) ?? .cycling
    }

    func updateUnit(_ unit: UnitOfSpeed) {
        defaults.setValue(unit.rawValue, forKey: "unitOfSpeed")
        self.unit = unit
    }

    func updateActivityType(_ type: ActivicyType) {
        defaults.setValue(type.rawValue, forKey: "activityType")
        self.activityType = type
    }
}
