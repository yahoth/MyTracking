//
//  HistoryViewController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/28/23.
//

import UIKit
import Combine

import SnapKit

class HistoryViewController: UIViewController {
    var tableView: UITableView!
    var vm: HistoryViewModel!
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        vm = HistoryViewModel()
        setTableView()
        bind()
    }

    func bind() {
        temp.$trackingData
            .receive(on: DispatchQueue.main)
            .sink { data in
                self.tableView.reloadData()
                print("reload: \(data)")
            }.store(in: &subscriptions)
    }

    func setTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        setTableViewSeparator()
        tableView.delegate = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        view.addSubview(tableView)
        setTableViewConstraints()

        func setTableViewSeparator() {
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = .brown
            tableView.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        }

        func setTableViewConstraints() {
            tableView.snp.makeConstraints { make in
                make.edges.equalTo(view)
            }
        }
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = vm.sortedGroups[indexPath.section].value[indexPath.row]
        let vc = TrackingResultViewController()

        vc.vm = TrackingResultViewModel(trackingData: item)
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension HistoryViewController: UITableViewDataSource {

    // UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.sortedGroups.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.sortedGroups[section].value.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var dateComponents = vm.sortedGroups[section].key
        dateComponents.timeZone = TimeZone.current
        let date = Calendar.current.date(from: dateComponents)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        dateFormatter.timeZone = TimeZone.current

        return dateFormatter.string(from: date)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else { return UITableViewCell() }
        let item = vm.sortedGroups[indexPath.section].value[indexPath.row]
        cell.configure(item: item)
        cell.selectionStyle = .none
        return cell
    }
}
