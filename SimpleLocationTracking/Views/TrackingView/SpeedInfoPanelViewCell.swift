//
//  SpeedInfoPanelViewCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/15/23.
//

import UIKit

/// label 공통
/// text color
/// font size
///
/// titleLabel
///
/// valueLabel
/// text alignment
///
/// unitLabel
///
/// contentView
/// corner Radius
/// background color
class SpeedInfoPanelViewCell: BaseSpeedInfoCell {

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
        contentView.backgroundColor = .orange
    }

    func configure(_ info: SpeedInfo) {
        titleLabel.text = info.title
        if info.title != "Time" {
            valueLabel.text = String(format: "%.1f", info.value as? Double ?? 0)
        } else {
            guard let time = info.value as? Int else { return }
            valueLabel.text = time.resultTime
        }
        unitLabel.text = info.unit
    }

}
