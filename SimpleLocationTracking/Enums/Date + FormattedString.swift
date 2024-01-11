//
//  Date + FormattedString.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 1/12/24.
//

import Foundation

extension Date {
    enum DateFormat: String {
        case yyyy_M = "yyyy년 M월"
        case yyyy_M_d = "yyyy년 M월 d일"
        case full = "yyyy년 M월 d일 h시 m분"
    }

    func formattedString(_ format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone.current

        return dateFormatter.string(from: self)
    }
}
