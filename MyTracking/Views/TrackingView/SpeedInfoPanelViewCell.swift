//
//  SpeedInfoPanelViewCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/15/23.
//

import UIKit

class SpeedInfoPanelViewCell: BaseSpeedInfoCell {
    deinit {
        print("SpeedInfoPanelViewCell deinit")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabels()
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabels() {
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textColor = .white

        valueLabel.font = .systemFont(ofSize: 28, weight: .bold)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .right

        unitLabel.font = .systemFont(ofSize: 20)
        unitLabel.textColor = .white
    }

    func setContentView() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .accent
    }

    func configure(_ info: SpeedInfo, unit: UnitOfSpeed) {

        titleLabel.text = info.title.localized()

        switch info.title {
        case "Average Speed", "Top Speed":
            unitLabel.text = unit.displayedSpeedUnit
            valueLabel.text = String(format: "%.0f", info.value.speedToSelectedUnit(unit))

        case "Distance":
            unitLabel.text = unit.correspondingDistanceUnit
            valueLabel.text = String(format: "%.2f", info.value.distanceToSelectedUnit(unit))

        case "Current Altitude":
            unitLabel.text = unit.correspondingAltitudeUnit
            valueLabel.text = String(format: "%.0f", info.value.altitudeToSelectedUnit(unit))

        default:
            break
        }
    }
}
