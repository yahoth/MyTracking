//
//  BaseSpeedInfoCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/29/23.
//

import UIKit

class BaseSpeedInfoCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    let container = UIStackView()

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
        label.setContentHuggingPriority(.required, for: .horizontal)
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

        [titleLabel, container].forEach { contentView.addSubview($0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.horizontalEdges.equalTo(contentView).inset(8)
        }

        container.axis = .horizontal
        container.spacing = 8
        container.alignment = .fill
        container.distribution = .fill
        container.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(contentView).inset(8)
            make.bottom.equalTo(contentView)
        }

        [valueLabel, unitLabel].forEach {
            container.addArrangedSubview($0)
        }
    }
}
