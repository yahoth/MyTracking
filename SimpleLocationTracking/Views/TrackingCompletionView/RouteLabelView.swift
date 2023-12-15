//
//  RouteLabelView.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/15/23.
//

import UIKit

import SnapKit

class RouteLabelView: UIView {

    let startContainer = UIView()
    let startPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "인천광역시 부평구 갈산동"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .brown
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.allowsDefaultTighteningForTruncation = true
        label.minimumScaleFactor = 0.25
        return label
    }()
    let endContainer = UIView()
    let endPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "인천광역시 부평구 갈산동"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .brown
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.allowsDefaultTighteningForTruncation = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    let startMarkLabel: UILabel = {
        let label = UILabel()
        label.text = "mark1"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .brown
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        return label
    }()    
    let endMarkLabel: UILabel = {
        let label = UILabel()
        label.text = "mark2"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .brown
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        return label
    }()

    let vStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setConstraints() {
        self.addSubview(vStackView)
//        self.backgroundColor = .green
        
//        vStackView.backgroundColor = .magenta
        vStackView.axis = .vertical
        vStackView.spacing = 20
        vStackView.alignment = .fill
        vStackView.distribution = .fillEqually

        vStackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        set(container: startContainer, label: startPlaceLabel, mark: startMarkLabel)
        set(container: endContainer, label: endPlaceLabel, mark: endMarkLabel)
    }

    func set(container: UIView, label: UILabel, mark: UILabel) {
        vStackView.addArrangedSubview(container)
        [label, mark].forEach(addSubview(_:))

        mark.snp.makeConstraints { make in
            make.top.bottom.equalTo(container).inset(8)
            make.leading.equalTo(container).offset(8)
        }

        label.snp.makeConstraints { make in
            make.centerX.equalTo(container)
//            make.centerY.equalTo(label)
            make.top.bottom.equalTo(container).inset(8)

            make.leading.equalTo(mark.snp.trailing).offset(10)
        }


    }
}

