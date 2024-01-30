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
    let vStack = UIStackView()

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
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.spacing = 4
        contentView.addSubview(vStack)
    }
    func setLabel(_ label: UILabel) {
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
    }

    func setImage() {
        periodImage.image = UIImage(systemName: "arrow.down")
        periodImage.tintColor = .gray
        periodImage.contentMode = .scaleAspectFit
    }

    func setConstraints() {
        [startDate, periodImage, endDate].forEach(vStack.addArrangedSubview(_:))
        vStack.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
//        startDate.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(contentView).inset(padding_body_body)
//        }
//        periodImage.snp.makeConstraints { make in
//            make.top.equalTo(startDate.snp.bottom).offset(10)
//            make.centerX.equalTo(contentView)
//            make.size.equalTo(20)
//        }
//        endDate.snp.makeConstraints { make in
//            make.top.equalTo(periodImage.snp.bottom).offset(10)
//            make.bottom.horizontalEdges.equalTo(contentView).inset(padding_body_body)
//        }
    }

    func configure(start: Date, end: Date) {
        startDate.text = start.formattedString(.full)
        endDate.text = end.formattedString(.full)
    }
}
