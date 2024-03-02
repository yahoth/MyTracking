//
//  TrackingResultPeriodCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 1/30/24.
//

import UIKit

import SnapKit

class TrackingResultPeriodCell: UITableViewCell {

    let startDate = UILabel()
    let endDate = UILabel()
    let periodImage = UIImageView()
    let hStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStackView()
        [startDate, endDate].forEach { setLabel($0) }
        setImage()

        setConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setStackView() {
        hStack.axis = .horizontal
        hStack.distribution = .fillProportionally
        hStack.spacing = 4
        contentView.addSubview(hStack)
    }
    func setLabel(_ label: UILabel) {
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
    }

    func setImage() {
        periodImage.image = UIImage(systemName: "arrow.right")
        periodImage.tintColor = .gray
        periodImage.contentMode = .scaleAspectFit
    }

    func setConstraints() {
        [startDate, periodImage, endDate].forEach(hStack.addArrangedSubview(_:))
        hStack.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
    }

    func configure(start: Date, end: Date) {
        startDate.text = start.formattedString(.hhmm)
        endDate.text = end.formattedString(.hhmm)
    }
}
