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

    let hStackView = UIStackView()

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

        [titleLabel, hStackView].forEach { contentView.addSubview($0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(padding_body_view)
            make.horizontalEdges.equalTo(contentView).inset(8)
        }

        hStackView.axis = .horizontal
        hStackView.spacing = 8
        hStackView.alignment = .fill
        hStackView.distribution = .fill
        hStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(contentView).inset(8)
            make.bottom.equalTo(contentView)
        }

        [valueLabel, unitLabel].forEach {
            hStackView.addArrangedSubview($0)
        }
    }
}
