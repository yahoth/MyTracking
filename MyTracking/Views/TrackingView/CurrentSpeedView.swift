//
//  CurrentSpeedView.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/8/23.
//

import UIKit

import SnapKit

class CurrentSpeedView: UIView {
    deinit {
        print("CurrentSpeedView")
    }

    let speedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 100, weight: .bold)
        label.textColor = .label

        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.allowsDefaultTighteningForTruncation = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    let unitButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .black)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setConstraints() {
        [speedLabel, unitButton].forEach(self.addSubview(_:))
        speedLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
        }

        unitButton.snp.makeConstraints { make in
            make.bottom.equalTo(speedLabel.snp.lastBaseline)
            make.leading.greaterThanOrEqualTo(speedLabel.snp.trailing)
            make.trailing.equalTo(self.snp.trailing).inset(20)
        }

    }

    func configure() {
        self.backgroundColor = .systemBackground
        speedLabel.text = "0"
    }
}
