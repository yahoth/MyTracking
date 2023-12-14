//
//  TrackingCompletionViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import Foundation

final class TrackingCompletionViewModel {
    var speedInfos: [SpeedInfo]

    init(speedInfos: [SpeedInfo]) {
        self.speedInfos = speedInfos
    }
}
