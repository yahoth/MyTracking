//
//  TrackingResultViewController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit

import SnapKit

class TrackingResultViewController: UIViewController {

    var tableView: UITableView!
    var vm: TrackingCompletionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Tracking Data"

        tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackingResultRouteCell.self, forCellReuseIdentifier: "TrackingResultRouteCell")
        tableView.register(TrackingResultSpeedInfoCell.self, forCellReuseIdentifier: "TrackingResultSpeedInfoCell")
//        tableView.register(TrackingResultHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

extension TrackingResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingResultRouteCell", for: indexPath) as? TrackingResultRouteCell else { return UITableViewCell() }
                cell.configure()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingResultSpeedInfoCell", for: indexPath) as? TrackingResultSpeedInfoCell else { return UITableViewCell() }
            cell.vm = vm
            cell.setCollectionViewConstraints(superViewHeight: view.frame.height)
            return cell
        }
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
//                    "sectionHeader") as! TrackingResultHeaderView
//        view.headerLabel.text = "dafafsdfs"
//        return view
//
//    }
}

extension TrackingResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
