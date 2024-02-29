//
//  SpeedInfoCollectionViewCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/15/23.
//

import UIKit

import SnapKit

class SpeedInfoCollectionViewCell: UICollectionViewCell {


    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    let unitLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    deinit {
        print("SpeedInfoCollectionViewCell deinit")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setTitle()
        setValue()
        setUnit()
        setContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle() {
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .left

        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    func setValue() {
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .left

        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.numberOfLines = 1
        valueLabel.allowsDefaultTighteningForTruncation = true
        valueLabel.minimumScaleFactor = 0.25
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
    func setUnit() {
        unitLabel.font = .systemFont(ofSize: 20)
        unitLabel.textColor = .label
        unitLabel.textAlignment = .left
        unitLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func setConstraints() {
        [titleLabel, valueLabel, unitLabel].forEach(contentView.addSubview(_:))

        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding_body_body)
            make.leading.equalTo(contentView)
            make.bottom.equalTo(contentView)/*.inset(padding_body_body)*/
        }

        unitLabel.snp.makeConstraints { make in
            make.leading.equalTo(valueLabel.snp.trailing)
            make.centerY.equalTo(valueLabel)
            make.trailing.equalTo(contentView)
        }
    }

    func setContentView() {
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .clear
    }

    func configure(_ info: SpeedInfo, unit: UnitOfSpeed) {
        titleLabel.text = info.title

        switch info.title {
        case "Distance":
            unitLabel.text = unit.correspondingDistanceUnit
            valueLabel.text = String(format: "%.1f", info.value.distanceToSelectedUnit(unit))

        case "Time":
            valueLabel.text = info.value.hhmmss

        case "Average Speed", "Top Speed":
            unitLabel.text = unit.displayedSpeedUnit
            valueLabel.text = String(format: "%.0f", info.value.speedToSelectedUnit(unit))

        case "Altitude":
            unitLabel.text = unit.correspondingAltitudeUnit
            valueLabel.text = String(format: "%.0f", info.value.altitudeToSelectedUnit(unit))
        default:
            break
        }
    }
}
