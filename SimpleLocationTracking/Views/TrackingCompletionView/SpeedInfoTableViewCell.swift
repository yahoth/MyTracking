//
//  SpeedInfoTableViewCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit

import SnapKit

class SpeedInfoTableViewCell: TrackingResultCell {

    var tempLabel: UILabel!
    var collectionView: UICollectionView!
    var vm: TrackingCompletionViewModel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTitle(to: "Speed Info")
        configureCollectionView()
        setCollectionViewConstraints()
        print("Speed info table view cell init")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(SpeedInfoCell.self, forCellWithReuseIdentifier: "SpeedInfoCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func setCollectionViewConstraints() {
        body.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(body)
        }
    }
}

extension SpeedInfoTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: /*(collectionView.frame.width - 30) / 2*/40 , height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }

}

extension SpeedInfoTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count: \(vm.speedInfos.count)")
        return vm.speedInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("info: \(vm.speedInfos)")

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpeedInfoCell", for: indexPath) as? SpeedInfoCell else {
            print("z")
            return UICollectionViewCell() }
        cell.configure(vm.speedInfos[indexPath.item])
        print(vm.speedInfos)
        return cell
    }
}
