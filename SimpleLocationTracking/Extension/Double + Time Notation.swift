//
//  Double + Time Notation.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/30/23.
//

import Foundation

extension Double {
    /// hh:mm:ss
    var hhmmss: String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = (Int(self) % 3600) % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    /// 1시간
    /// 1시간 1분
    /// 1분 48초
    /// 1분
    /// 48초
    var resultTime: String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = (Int(self) % 3600) % 60

        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else if minutes > 0 && seconds > 0 {
            return "\(minutes)분 \(seconds)초"
        } else if minutes > 0 {
            return "\(minutes)분"
        } else {
            return "\(seconds)초"
        }
    }

}
