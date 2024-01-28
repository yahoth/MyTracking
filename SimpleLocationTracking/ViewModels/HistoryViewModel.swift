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
    
    deinit {
        print("HistoryViewModel deinit")
    }

    var trackingDatas: Results<TrackingData> {
        realmManager.read()
    }

    func addChangeListener(_  handler: @escaping (RealmCollectionChange<Results<TrackingData>>) -> ()) {
        realmManager.notificationToken =
        trackingDatas.observe { changes in handler(changes) }
    }
//
//    var groupedItems: [DateComponents: List<TrackingData>] {
//        let grouped = Dictionary(grouping: trackingDatas) { item in
//            Calendar.current.dateComponents([.year, .month], from: item.startDate)
//
//        }
//
//        return grouped.mapValues { items in
//            return items.sorted { lhs, rhs -> Bool in
//                return lhs.startDate > rhs.startDate
//            }.toRealmList()
//        }
//    }
//
//    // 월을 기준으로 정렬합니다.
//    var sortedGroups: [Dictionary<DateComponents, List<TrackingData>>.Element] {
//        groupedItems.sorted { lhs, rhs in
//            let lhsDate = Calendar.current.date(from: lhs.key)!
//            let rhsDate = Calendar.current.date(from: rhs.key)!
//            return lhsDate > rhsDate
//        }
//    }

}
