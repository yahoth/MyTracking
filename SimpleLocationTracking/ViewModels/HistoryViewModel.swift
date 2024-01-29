//
//  HistoryViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/30/23.
//

import UIKit

import RealmSwift

class HistoryViewModel {

    let realmManager = RealmManager.shared
    let settingManager = SettingManager.shared

    deinit {
        print("HistoryViewModel deinit")
    }

    var trackingDatas: Results<TrackingData> {
        realmManager.read()
    }

    var unitOfSpeed: UnitOfSpeed {
        settingManager.unit
    }

    func addChangeListener(_  handler: @escaping (RealmCollectionChange<Results<TrackingData>>) -> ()) {
        realmManager.notificationToken =
        trackingDatas.observe { changes in handler(changes) }
    }
//
//    var groupedItems: [DateComponents: [TrackingData]] {
//        let grouped = Dictionary(grouping: trackingDatas) { item in
//            Calendar.current.dateComponents([.year, .month], from: item.startDate)
//        }
//
//        return grouped.mapValues { items in
//            return items.sorted { lhs, rhs -> Bool in
//                return lhs.startDate > rhs.startDate
//            }
//        }
//    }
//
//    // 월을 기준으로 정렬합니다.
//    var sortedGroups: [Dictionary<DateComponents, [TrackingData]>.Element] {
//        groupedItems.sorted { lhs, rhs in
//            let lhsDate = Calendar.current.date(from: lhs.key)!
//            let rhsDate = Calendar.current.date(from: rhs.key)!
//            return lhsDate > rhsDate
//        }
//    }

    var dic: [String: [TrackingData]] {
        Dictionary(grouping: trackingDatas, by:  { $0.monthlyIdentifier })
    }

    var keys: [String] {
        // given: "2024-5", "2024-4", "2024-6"
        // sorted: "2024-4", "2024-5", "2024-6"
//        let dateComponents = dic.keys.map { keys in
//            let dc = keys.components(separatedBy: "-").compactMap { Int($0) }
//            guard let year = dc.first, let month = dc.last else { return }
//            let calendar = Calendar(identifier: .gregorian)
//            let dateComponent = DateComponents(calendar: calendar, year: year, month: month)
//
//        }

        dic.keys.sorted { key1, key2 in
            let date1 = key1.components(separatedBy: "-")
            let date2 = key2.components(separatedBy: "-")

            if let year1 = Int(date1[0]), let year2 = Int(date2[0]), let month1 = Int(date1[1]), let month2 = Int(date2[1]) {
                if year1 == year2 {
                    return month1 < month2
                } else {
                    return year1 < year2
                }
            }
            return key1 < key2
        }
    }
}
