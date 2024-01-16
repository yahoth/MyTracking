//
//  HistoryViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/30/23.
//

import UIKit

import RealmSwift

class HistoryViewModel {
    let realmManager = RealmManager()

    var trackingDatas: Results<TrackingData> {
        realmManager.read()
    }

    var groupedItems: [DateComponents: List<TrackingData>] {
        let grouped = Dictionary(grouping: trackingDatas) { item in
            Calendar.current.dateComponents([.year, .month], from: item.startDate)

        }

        return grouped.mapValues { items in
            return items.sorted { lhs, rhs -> Bool in
                return lhs.startDate > rhs.startDate
            }.toRealmList()
        }
    }

    // 월을 기준으로 정렬합니다.
    var sortedGroups: [Dictionary<DateComponents, List<TrackingData>>.Element] {
        groupedItems.sorted { lhs, rhs in
            let lhsDate = Calendar.current.date(from: lhs.key)!
            let rhsDate = Calendar.current.date(from: rhs.key)!
            return lhsDate > rhsDate
        }
    }

    func addChangeListener(_ tableView: UITableView?) {
        realmManager.notificationToken =
        trackingDatas.observe { changes in
            if let tableView {
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    //                    tableView.beginUpdates()
                    tableView.performBatchUpdates {
                        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                    }
                    //                    tableView.endUpdates()
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        }
    }
}
