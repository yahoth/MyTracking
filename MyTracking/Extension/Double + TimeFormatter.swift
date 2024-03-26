//
//  Double + TimeFormatter.swift
//  MyTracking
//
//  Created by TAEHYOUNG KIM on 3/26/24.
//

import Foundation

extension Double {
    /// time을 로컬라이징하여 포맷팅
    /// ex) 20초 -> 20s
    var timeFormatter: String {

        let time = Int(self)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        let localeID = Locale.preferredLanguages.first
        if #available(iOS 16, *) {
            let deviceLocale = Locale(identifier: localeID ?? "en_US").language.languageCode?.identifier
            formatter.calendar?.locale = Locale(identifier: deviceLocale ?? "en_US")
        } else {
            let deviceLocale = Locale(identifier: localeID ?? "en_US").languageCode
            formatter.calendar?.locale = Locale(identifier: deviceLocale ?? "en_US")
        }

        // 1시간 초과될 경우 초 단위 표시 안함
        formatter.allowedUnits = time < 3600 ? [.minute, .second] : [.hour, .minute]

        return formatter.string(from: TimeInterval(time)) ?? ""
    }
}
