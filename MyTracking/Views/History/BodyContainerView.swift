//
//  BodyContainerView.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 1/24/24.
//


import UIKit

import SnapKit

class BodyContainerView: UIView {

    /// Labels
    let fromLabel = UILabel()
    let toLabel = UILabel()
    let timeLabel = UILabel()
    let distanceLabel = UILabel()

    /// 실제 밸류(데이터) 값
    let startLocation = UILabel()
    let endLocation = UILabel()
    let time = UILabel()
    let distance = UILabel()

    var stackView: UIStackView!

    func setStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(padding_body_view)
        }
    }

    fileprivate func setLabelContainer(leftLabel: UILabel, rightLabel: UILabel) {
        let container = UIView()
        stackView.addArrangedSubview(container)
        [leftLabel, rightLabel].forEach(container.addSubview(_:))
        leftLabel.snp.makeConstraints { make in
            make.width.equalTo(container).multipliedBy(0.7)
            make.leading.top.equalTo(container)
            make.bottom.equalTo(container)
        }
        rightLabel.snp.makeConstraints { make in
            make.width.equalTo(container).multipliedBy(0.25)
            make.trailing.equalTo(container)
            make.top.equalTo(leftLabel.snp.top)
            make.bottom.equalTo(container)
            make.leading.greaterThanOrEqualTo(leftLabel.snp.trailing)
        }
    }

    func setEmptySpacing() {
        let view = UIView()
        view.backgroundColor = .clear
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.height.equalTo(10)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        [fromLabel, toLabel, timeLabel, distanceLabel].forEach(setLabels(_:))
        [startLocation, endLocation, distance].forEach(setDataLabels(_:))
        setTimeLabel()
        setStackView()

        setLabelContainer(leftLabel: fromLabel, rightLabel: timeLabel)
        setLabelContainer(leftLabel: startLocation, rightLabel: time)
        setEmptySpacing()
        setLabelContainer(leftLabel: toLabel, rightLabel: distanceLabel)
        setLabelContainer(leftLabel: endLocation, rightLabel: distance)

        configureLabels()
    }

    func setLabels(_ label: UILabel) {
        label.textColor = .gray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 1
    }

    func setDataLabels(_ label: UILabel) {
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
    }

    func setTimeLabel() {
        time.font = .boldSystemFont(ofSize: 20)
        time.textColor = .black
        time.numberOfLines = 1
        time.adjustsFontSizeToFitWidth = true
        time.minimumScaleFactor = 0.5
    }

    func configureLabels() {
        fromLabel.text = "From".localized()
        toLabel.text = "To".localized()
        timeLabel.text = "Time".localized()
        distanceLabel.text = "Distance".localized()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
