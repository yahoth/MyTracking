//
//  SpeedInfoCollectionViewCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/15/23.
//

import UIKit

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
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = .gray
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

        valueLabelText()

        unitLabel.text = info.unit

        func valueLabelText() {
            switch info.title {
            case "Time":
//                guard let time = info.value else { return }
                valueLabel.text = info.value.resultTime
                valueLabel.font = .systemFont(ofSize: 15, weight: .bold)
            case "Altitude", "Floor":
                valueLabel.text = String(format: "%.0f", info.value)
            default:
                valueLabel.text = String(format: "%.1f", info.value)
            }
        }
    }
}
