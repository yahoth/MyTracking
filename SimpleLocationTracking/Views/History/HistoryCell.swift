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
        view.backgroundColor = .systemBackground
        return view
    }()

    var typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .accent
        imageView.contentMode = .scaleAspectFit
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

    func setTopContainerConstraints() {
        typeImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.edges.equalTo(typeImageContainer).inset(10)
        }

        typeImageContainer.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(topContainer).inset(padding_body_view)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeImageContainer.snp.trailing).offset(padding_body_body)
            make.centerY.equalTo(typeImageContainer)
            make.trailing.lessThanOrEqualTo(topContainer)
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
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        contentView.addSubview(topStackView)
        setConstraints()
        setTopContainer()
        setTopContainerConstraints()
        setMidContainer()
        setMidContainerConstraints()
        setBottmContainer()
        setBottomContainerConstraints()
        typeImageContainer.layer.masksToBounds = true
    }

    func setConstraints() {
        topStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }

    func configure(item: TrackingData, unit: UnitOfSpeed) {
        dateLabel.text = item.startDate.formattedString(.medium)
        typeImageView.image = UIImage(named: item.activityType.image)

        bodyContainer.startLocation.text = item.startLocation
        bodyContainer.endLocation.text = item.endLocation
        bodyContainer.time.text = timeFormatter(Int(item.speedInfos.first { $0.title == "Time" }?.value ?? 0))
                let distanceInfo = item.speedInfos.first { $0.title == "Distance" }
        bodyContainer.distance.text = "\(String(format: "%.1f", distanceInfo?.value.distanceToSelectedUnit(unit) ?? 0)) \(unit.correspondingDistanceUnit)"
    }


    func timeFormatter(_ time: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        let localeID = Locale.preferredLanguages.first
        if #available(iOS 16, *) {
            let deviceLocale = Locale(identifier: localeID ?? "en_US").language.languageCode?.identifier
            formatter.calendar?.locale = Locale(identifier: deviceLocale ?? "en_US")
        } else {
            let deviceLocale = Locale(identifier: localeID ?? "en_US").languageCode
            formatter.calendar?.locale = Locale(identifier: deviceLocale ?? "en_US")
        }

        // 1시간 초과될 경우 초 단위 표시 안함
        formatter.allowedUnits = time < 3600 ? [.minute, .second] : [.hour, .minute]

        return formatter.string(from: TimeInterval(time)) ?? ""
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
