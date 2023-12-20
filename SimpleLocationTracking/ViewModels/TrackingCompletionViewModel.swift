//
//  TrackingCompletionViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit
import CoreLocation

final class TrackingCompletionViewModel {
    var speedInfos: [SpeedInfo]

    @Published var path: [PathInfo]
//    @Published var span: MKCoordinateSpan?
    @Published var image: UIImage?

    init(speedInfos: [SpeedInfo], path: [PathInfo]) {
        self.speedInfos = speedInfos
        self.path = path
    }
}
