//
//  SpeedInfoCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/29/23.
//

import UIKit

class SpeedInfoCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    let container = UIStackView()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.allowsDefaultTighteningForTruncation = true
        label.minimumScaleFactor = 0.25
        label.textAlignment = .right
        return label
    }()

    let unitLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
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
        contentView.layer.cornerRadius = 12        
        contentView.backgroundColor = .orange

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

    func configure(_ info: SpeedInfo) {
        titleLabel.text = info.title
        if info.title != "Time" {
            valueLabel.text = String(format: "%.1f", info.value as? Double ?? 0)
        } else {
            valueLabel.text = info.value as? String ?? ""
        }
        unitLabel.text = info.unit
    }
}
