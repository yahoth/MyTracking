//
//  TrackingResultSpeedInfoCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit

import SnapKit

class TrackingResultSpeedInfoCell: BaseTrackingResultCell {

    var collectionView: UICollectionView!
    var vm: TrackingResultViewModel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTitle(to: "Speed Info")
        configureCollectionView()
        setCollectionViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(SpeedInfoCollectionViewCell.self, forCellWithReuseIdentifier: "SpeedInfoCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func setCollectionViewConstraints(/*superViewHeight: CGFloat?*/) {
        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding_body_view)
            make.horizontalEdges.equalTo(contentView).inset(padding_body_view)
            make.bottom.equalTo(contentView).inset(padding_body_view)
            make.height.equalTo(400)
        }
    }
    func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension TrackingResultSpeedInfoCell: UICollectionViewDelegateFlowLayout {
}

extension TrackingResultSpeedInfoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.speedInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpeedInfoCollectionViewCell", for: indexPath) as? SpeedInfoCollectionViewCell else {
            return UICollectionViewCell() }
        cell.configure(vm.speedInfos[indexPath.item], unit: SettingManager.shared.unit)
        return cell
    }
}
