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
    var subscriptions = Set<AnyCancellable>()
    typealias Item = TrackingData
    struct Section: Hashable {
        let keys: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        vm = HistoryViewModel()
        createCollectionView()
        createDatasource()
        updateCollectionView()
        addRefreshControl()
        bind()


    }

    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc func refresh() {
        applySnapshot()
        collectionView.refreshControl?.endRefreshing()
    }


    func createCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        collectionView.register(HistoryCell.self, forCellWithReuseIdentifier: "HistoryCell")
//        collectionView.register(HistoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HistoryHeaderView.identifier)
        collectionView.delegate = self
    }

    func createDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else { return nil }
            cell.configure(item: item, unit: self?.vm.unitOfSpeed ?? .kmh)
            return cell
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, elementKind, indexPath) in
            let section = self.datasource.snapshot().sectionIdentifiers[indexPath.section]
            var content = supplementaryView.defaultContentConfiguration()
            content.text = section.keys
            supplementaryView.contentConfiguration = content
        }

        datasource.supplementaryViewProvider = { (_, _, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }

        let snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        datasource.apply(snapshot)
    }

    func updateCollectionView() {
        vm.addChangeListener { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial, .update:
                self.applySnapshot()
            case .error(let error):
                print("collection view update error: \(error)")
            }
        }
    }

    func applySnapshot() {
        var snapshot = datasource.snapshot()
        snapshot.deleteAllItems()
        let sections = vm.keys.map { Section(keys: $0) }
        snapshot.appendSections(sections.reversed())
        sections.forEach { snapshot.appendItems(vm.dic[$0.keys] ?? [], toSection: $0) }
        datasource.apply(snapshot)
    }

    func delete(item: TrackingData) {
        var snapshot = datasource.snapshot()
        let section = snapshot.sectionIdentifier(containingItem: item)!
        snapshot.deleteItems([item])

        if snapshot.itemIdentifiers(inSection: section).isEmpty {
            snapshot.deleteSections([section])
        }

        datasource.apply(snapshot) { [weak self] in
            self?.vm.realmManager.deleteObjectsOf(type: item)
        }
    }

    func bind() {
        vm.settingManager.$unit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
    }

    func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        section.interGroupSpacing = padding_body_body
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding_body_view, bottom: padding_body_view, trailing: padding_body_view)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

//    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
//        guard let indexPath, let item = datasource.itemIdentifier(for: indexPath) else { return nil }
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
//            self?.delete(item: item)
//            completion(false)
//        }
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }

    private func makeDeleteContextualAction(forRowAt indexPath: IndexPath) -> UIAction {
        return UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            guard let self, let item = self.datasource.itemIdentifier(for: indexPath) else { return }
            self.delete(item: item)
        }
    }
}

extension HistoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TrackingResultViewController()
        vc.vm = TrackingResultViewModel(trackingData: vm.selectedItem(at: indexPath) ?? TrackingData(), viewType: .navigation)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else { return UIMenu() }
            let deleteAction = self.makeDeleteContextualAction(forRowAt: indexPath)
            return UIMenu(title: "", children: [deleteAction])
        }
        return configuration
    }
}
