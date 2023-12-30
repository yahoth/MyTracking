//
//  HistoryViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/30/23.
//

import Foundation

class TempData {
    @Published var trackingData: [TrackingData] = []
}

var temp = TempData()

class HistoryViewModel {
    var items: [TrackingData] {
        temp.trackingData
    }

    var groupedItems: [DateComponents: [TrackingData]] {
        let grouped = Dictionary(grouping: items) { item in
            Calendar.current.dateComponents([.year, .month], from: item.startDate)

        }

        return grouped.mapValues { items in
            return items.sorted { lhs, rhs -> Bool in
                return lhs.startDate > rhs.startDate
            }
        }
    }

    // 월을 기준으로 정렬합니다.
    var sortedGroups: [Dictionary<DateComponents, [TrackingData]>.Element] {
        groupedItems.sorted { lhs, rhs in
            let lhsDate = Calendar.current.date(from: lhs.key)!
            let rhsDate = Calendar.current.date(from: rhs.key)!
            return lhsDate > rhsDate
        }
    }
}
