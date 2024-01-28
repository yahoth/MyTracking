//
//  HistoryViewController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/28/23.
//

import UIKit
import Combine

import SnapKit
import RealmSwift

class HistoryViewController: UIViewController {

    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    var collectionView: UICollectionView!
    var vm: HistoryViewModel!

    typealias Item = TrackingData
    enum Section {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground        
        vm = HistoryViewModel()
        createCollectionView()
        createDatasource()
        updateCollectionView()
    }

    func createCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        collectionView.register(HistoryCell.self, forCellWithReuseIdentifier: "HistoryCell")
        collectionView.register(HistoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HistoryHeaderView.identifier)
        collectionView.delegate = self
    }

    func createDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView) { /*[weak self]*/ collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else { return nil }
//            let item = self?.vm.sortedGroups[indexPath.section].value[indexPath.row]
//            cell.configure(item: item ?? TrackingData())
            cell.configure(item: item)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        datasource.apply(snapshot)
    }

    func updateCollectionView() {
        vm.addChangeListener { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial, .update:
                self.applySnapshot(item: self.vm.trackingDatas)
            case .error(let error):
                print("collection view update error: \(error)")
            }
        }
    }

    func applySnapshot(item: Results<TrackingData>) {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(item))
        datasource.apply(snapshot)
    }

    func layout() -> UICollectionViewCompositionalLayout {

        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            return section
        }
        return layout
    }
}

extension HistoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = vm.trackingDatas[indexPath.section]
        let vc = TrackingResultViewController()
        vc.vm = TrackingResultViewModel(trackingData: item, viewType: .navigation)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//
//class HistoryViewController: UIViewController {
//    deinit {
//        print("HistoryViewController deinit")
//    }
//
//    var tableView: UITableView!
//    var vm: HistoryViewModel!
//    var subscriptions = Set<AnyCancellable>()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        navigationItem.title = "Tracking History"
//        vm = HistoryViewModel()
//        setTableView()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        vm.addChangeListener(tableView)
//    }
//
//
//    func setTableView() {
//        tableView = UITableView(frame: .zero, style: .plain)
//        tableView.dataSource = self
//        tableView.delegate = self
//        setTableViewSeparator()
//        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
//        view.addSubview(tableView)
//        setTableViewConstraints()
//
//        func setTableViewSeparator() {
//            tableView.separatorStyle = .singleLine
//            tableView.separatorColor = .brown
//            tableView.separatorInset = .init(top: 0, left: padding_body_view, bottom: 0, right: padding_body_view)
//        }
//
//        func setTableViewConstraints() {
//            tableView.snp.makeConstraints { make in
//                make.edges.equalTo(view)
//            }
//        }
//    }
//}
//
//extension HistoryViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = vm.sortedGroups[indexPath.section].value[indexPath.row]
//        let vc = TrackingResultViewController()
//        vc.vm = TrackingResultViewModel(trackingData: item, viewType: .navigation)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
//extension HistoryViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return vm.sortedGroups.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return vm.sortedGroups[section].value.count
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        var dateComponents = vm.sortedGroups[section].key
//        dateComponents.timeZone = TimeZone.current
//        let date = Calendar.current.date(from: dateComponents)!
//        return date.formattedString(.yyyy_M)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else { return UITableViewCell() }
//        let item = vm.sortedGroups[indexPath.section].value[indexPath.row]
//        cell.configure(item: item)
//        cell.selectionStyle = .none
//        return cell
//    }
//}
