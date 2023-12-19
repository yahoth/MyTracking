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
    var startPlaceLabel: UILabel!

    let endContainer = UIView()
    var endPlaceLabel: UILabel!

    var startMarkLabel: UILabel!
    var endMarkLabel: UILabel!
    var vStackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setPlaceLabels()
        setMarkLabels()
        setVStack()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPlaceLabels() {
        startPlaceLabel = UILabel()
        endPlaceLabel = UILabel()
        [startPlaceLabel, endPlaceLabel].forEach { label in
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 1
            label.allowsDefaultTighteningForTruncation = true
            label.minimumScaleFactor = 0.25
        }
    }

    func setMarkLabels() {
        startMarkLabel = UILabel()
        startMarkLabel.text = "🏁"
        endMarkLabel = UILabel()
        endMarkLabel.text = "⛳️"
        [startMarkLabel, endMarkLabel].forEach {
            $0.font = .systemFont(ofSize: 15)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }
    func setVStack() {
        vStackView = UIStackView()
        self.addSubview(vStackView)
        vStackView.axis = .vertical
        vStackView.spacing = 0
        vStackView.alignment = .fill
        vStackView.distribution = .fillEqually
    }

    func setConstraints() {
        vStackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        set(container: startContainer, label: startPlaceLabel, mark: startMarkLabel)
        set(container: endContainer, label: endPlaceLabel, mark: endMarkLabel)
    }

    func set(container: UIView, label: UILabel, mark: UILabel) {
        vStackView.addArrangedSubview(container)
        [label, mark].forEach(container.addSubview(_:))
        mark.snp.makeConstraints { make in
            make.top.bottom.equalTo(container).inset(8)
            make.leading.equalTo(container).offset(8)
        }

        label.snp.makeConstraints { make in
            make.centerX.equalTo(container)
            make.top.bottom.equalTo(container).inset(8)
            make.leading.equalTo(mark.snp.trailing).offset(10)
        }
    }
}

