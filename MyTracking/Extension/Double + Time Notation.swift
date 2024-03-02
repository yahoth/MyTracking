//
//  Double + Time Notation.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/30/23.
//

import Foundation

extension Double {
    var hours: Int {
        Int(self) / 3600
    }

    var minutes: Int {
        (Int(self) % 3600) / 60
    }

    var seconds: Int {
        (Int(self) % 3600) % 60
    }

    /// hh:mm:ss
    var hhmmss: String {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    /// 1시간
    /// 1시간 1분
    /// 1분 48초
    /// 1분
    /// 48초
    var resultTime: String {
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

    var hhmm: String {
        return String(format: "%02d:%02d", hours, minutes)
    }

}
