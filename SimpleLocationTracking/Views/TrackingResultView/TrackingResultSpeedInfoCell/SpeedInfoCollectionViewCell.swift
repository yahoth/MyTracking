//
//  SpeedInfoCollectionViewCell.swift
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
class SpeedInfoCollectionViewCell: SpeedInfoItemCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabels()
        setContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLabels() {
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        valueLabel.font = .systemFont(ofSize: 15, weight: .bold)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .left

        unitLabel.font = .systemFont(ofSize: 15)
        unitLabel.textColor = .label
    }

    func setContentView() {
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .clear
    }

    func configure(_ info: SpeedInfo) {
        titleLabel.text = info.title
        if info.title != "Time" {
            valueLabel.text = String(format: "%.1f", info.value as? Double ?? 0)
        } else {
            guard let time = info.value as? Int else { return }
            valueLabel.text = time.resultTime
            valueLabel.font = .systemFont(ofSize: 15)
        }
        unitLabel.text = info.unit
    }
}