//
//  Stopwatch.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/30/23.
//

import Foundation
import Combine

class Stopwatch {
    deinit {
        print("Stopwatch deinit")
    }

    private var timer: AnyCancellable?
    @Published var count: Double = 0

    func start() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.count += 1
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
