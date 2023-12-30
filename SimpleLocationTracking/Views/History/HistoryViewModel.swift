//
//  HistoryViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/30/23.
//

import Foundation

class HistoryViewModel {

    var items: [Temp] {
        let calendar = Calendar.current
        let items =
        [
            Temp(str: "1", date: calendar.date(from: DateComponents(year: 2022, month: 5, day: 1))!),
            Temp(str: "2", date: calendar.date(from: DateComponents(year: 2022, month: 5, day: 2))!),
            Temp(str: "3", date: calendar.date(from: DateComponents(year: 2023, month: 11, day: 3))!),
            Temp(str: "4", date: calendar.date(from: DateComponents(year: 2023, month: 11, day: 4))!),
        ]

        return items
    }

    var groupedItems: [DateComponents: [Temp]] {
        let grouped = Dictionary(grouping: items) { item in
        Calendar.current.dateComponents([.year, .month], from: item.date)

        }
        return grouped.mapValues { items in
            return items.sorted { lhs, rhs -> Bool in
                return lhs.date > rhs.date
            }
        }
    }

    // 월을 기준으로 정렬합니다.
    var sortedGroups: [Dictionary<DateComponents, [Temp]>.Element] {
        groupedItems.sorted { lhs, rhs in
            let lhsDate = Calendar.current.date(from: lhs.key)!
            let rhsDate = Calendar.current.date(from: rhs.key)!
            return lhsDate > rhsDate
        }
    }
}
