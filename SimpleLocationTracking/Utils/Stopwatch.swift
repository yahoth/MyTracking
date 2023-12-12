//
//  Stopwatch.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/30/23.
//

import Foundation
import Combine

class Stopwatch: ObservableObject {

    private var timer: AnyCancellable?
    @Published var count = 0

    func start() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.count += 1
            }
    }

    func pause() {
        timer?.cancel()
    }

    func stop() {
        timer?.cancel()
        timer = nil
        count = 0
    }
}
