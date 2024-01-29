//
//  Date + FormattedString.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 1/12/24.
//

import Foundation

extension Date {
    enum DateFormat: String {
        case full = "yMMMdhm"
        case medium = "MMMdhm"
        case timeOnly = "hm"
    }

    func formattedString(_ format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        let localeID = Locale.preferredLanguages.first

        if #available(iOS 16, *) {
            let deviceLocale = Locale(identifier: localeID ?? "en_US").language.languageCode?.identifier
            dateFormatter.locale = Locale(identifier: deviceLocale ?? "en_US")
        } else {
            let deviceLocale = Locale(identifier: localeID ?? "en_US").languageCode
            dateFormatter.locale = Locale(identifier: deviceLocale ?? "en_US")
        }

        dateFormatter.setLocalizedDateFormatFromTemplate(format.rawValue)
        return dateFormatter.string(from: self)
    }
}
