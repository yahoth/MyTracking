//
//  TrackingResultRouteCellViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/20/23.
//

import Foundation

class TrackingResultRouteCellViewModel {
    @Published var path: [PathInfo]

    init(path: [PathInfo]) {
        self.path = path
    }
}
