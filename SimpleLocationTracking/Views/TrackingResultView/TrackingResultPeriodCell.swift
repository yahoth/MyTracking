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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [startDate, endDate].forEach { setLabel($0) }
        setImage()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLabel(_ label: UILabel) {
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 1
        contentView.addSubview(label)
    }

    func setImage() {
        periodImage.image = UIImage(systemName: "arrow.down")
        periodImage.tintColor = .gray
        periodImage.contentMode = .scaleAspectFit
        contentView.addSubview(periodImage)
    }

    func setConstraints() {
        startDate.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(padding_body_view)
        }
        periodImage.snp.makeConstraints { make in
            make.top.equalTo(startDate.snp.bottom)/*.offset(padding_body_body)*/
            make.horizontalEdges.equalTo(contentView).inset(padding_body_view)
            make.size.equalTo(20)
        }
        endDate.snp.makeConstraints { make in
            make.top.equalTo(periodImage.snp.bottom)/*.offset(padding_body_body)*/
            make.bottom.horizontalEdges.equalTo(contentView).inset(padding_body_view)
        }
    }

    func configure(start: Date, end: Date) {
        startDate.text = start.formattedString(.full)
        endDate.text = end.formattedString(.full)
    }
}
