//
//  SpeedInfo.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/8/23.
//

import Foundation

import RealmSwift

class SpeedInfo: Object {
    @Persisted var value: Double
    @Persisted var unit: String? = nil
    @Persisted var title: String

    convenience init(value: Double, unit: String? = nil, title: String) {
        self.init()
        self.value = value
        self.unit = unit
        self.title = title
    }
}
