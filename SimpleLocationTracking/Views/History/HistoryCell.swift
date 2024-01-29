//
//  HistoryCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/29/23.
//

import UIKit

import SnapKit


class HistoryCell: UICollectionViewCell {

    /// 최상단 스택 컨테이너
    var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .blue
        return stackView
    }()

    /// 상단 컨테이너 및 UI
    var topContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        return view
    }()

    var typeImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    var typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .accent
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "figure.outdoor.cycle")
        return imageView
    }()

    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    func setTopContainer() {
        topStackView.addArrangedSubview(topContainer)
        [typeImageContainer, dateLabel].forEach(topContainer.addSubview(_:))
        typeImageContainer.addSubview(typeImageView)
    }

    // height: 약 82
    func setTopContainerConstraints() {
        typeImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.edges.equalTo(typeImageContainer).inset(10)
        }

        typeImageContainer.snp.makeConstraints { make in
            make.centerY.equalTo(topContainer)
            make.leading.top.equalTo(topContainer).inset(16)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(topContainer)
            make.top.trailing.equalTo(topContainer).inset(16)
            make.leading.equalTo(typeImageContainer.snp.trailing).offset(10)
        }
    }

    /// 중간부 컨테이너
    var bodyContainer = BodyContainerView()

    func setMidContainer() {
        topStackView.addArrangedSubview(bodyContainer)
    }

    func setMidContainerConstraints() {
    }

    func setBottmContainer() {
        topStackView.addArrangedSubview(bottomContainer)
    }

    //height: 20
    func setBottomContainerConstraints() {
        bottomContainer.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }



    /// 하단 컨테이너
    var bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .accent
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        typeImageContainer.layer.cornerRadius = 25
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12 // 원하는 radius 값을 설정하세요.
        contentView.layer.masksToBounds = true

        contentView.addSubview(topStackView)
        setConstraints()
        setTopContainer()
        setTopContainerConstraints()
        setMidContainer()
        setMidContainerConstraints()
        setBottmContainer()
        setBottomContainerConstraints()
    }

    func setConstraints() {
        topStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }

    func configure(item: TrackingData, unit: UnitOfSpeed) {
        dateLabel.text = item.startDate.formattedString(.m_d_h_m)
        bodyContainer.startLocation.text = item.startLocation
        bodyContainer.endLocation.text = item.endLocation
        bodyContainer.time.text = item.speedInfos.first { $0.title == "Time" }?.value.hhmmss
        let distanceInfo = item.speedInfos.first { $0.title == "Distance" }
        bodyContainer.distance.text = "\(String(format: "%.1f", distanceInfo?.value.distanceToSelectedUnit(unit) ?? 0)) \(unit.correspondingDistanceUnit)"
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
