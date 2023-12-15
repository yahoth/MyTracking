//
//  SpeedInfoItemCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/15/23.
//

import UIKit

class SpeedInfoItemCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.allowsDefaultTighteningForTruncation = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    let unitLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        [titleLabel, valueLabel, unitLabel].forEach(contentView.addSubview(_:))

        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView)
            make.bottom.lessThanOrEqualTo(contentView).inset(8)
        }

        unitLabel.snp.makeConstraints { make in
            make.leading.equalTo(valueLabel.snp.trailing)
            make.centerY.equalTo(valueLabel)
            make.trailing.lessThanOrEqualTo(contentView)
        }
    }
}
