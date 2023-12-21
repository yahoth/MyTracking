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
    var vm: TrackingCompletionViewModel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTitle(to: "Speed Info")
        configureCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(SpeedInfoCollectionViewCell.self, forCellWithReuseIdentifier: "SpeedInfoCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func setCollectionViewConstraints(superViewHeight: CGFloat) {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding_title_body)
            make.horizontalEdges.bottom.equalTo(contentView).inset(UIEdgeInsets(top: 0, left: padding_body_view, bottom: 0, right: padding_body_view))
            make.height.equalTo(superViewHeight / 3.5)
        }
    }
}

extension TrackingResultSpeedInfoCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10) / 2 , height: (collectionView.frame.height - 20) / 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

extension TrackingResultSpeedInfoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.speedInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpeedInfoCollectionViewCell", for: indexPath) as? SpeedInfoCollectionViewCell else {
            return UICollectionViewCell() }
        cell.configure(vm.speedInfos[indexPath.item])
        return cell
    }
}
