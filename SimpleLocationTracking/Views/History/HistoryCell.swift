//
//  HistoryCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/29/23.
//

import UIKit

import SnapKit

class HistoryCell: UITableViewCell {
    let startPlaceLabel = UILabel()
    let endPlaceLabel = UILabel()
    let tripTypeImage = UIImageView()
    let dateLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDateLabel(dateLabel)
        set(startPlaceLabel)
        set(endPlaceLabel)
        set(tripTypeImage)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(_ tripTypeImage: UIImageView) {
        tripTypeImage.contentMode = .scaleAspectFit
        addSubview(tripTypeImage)
    }

    func set(_ label: UILabel) {
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .center
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.85
//        label.lineBreakMode = .byTruncatingTail
//        label.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addSubview(label)
    }

    func setDateLabel(_ label: UILabel) {
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        contentView.addSubview(label)
    }

    func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(padding_body_view)
            make.height.equalTo(20)
            make.horizontalEdges.equalTo(contentView).inset(padding_body_view)
        }

        startPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(padding_body_body)
            make.height.equalTo(20)
            make.horizontalEdges.equalTo(contentView).inset(padding_body_view)
        }

        tripTypeImage.snp.makeConstraints { make in
            make.top.equalTo(startPlaceLabel.snp.bottom).offset(padding_body_body)
            make.centerX.equalTo(contentView).inset(padding_body_view)
            make.height.width.equalTo(20)
        }

        endPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(tripTypeImage.snp.bottom).offset(padding_body_body)
            make.height.equalTo(20)
            make.horizontalEdges.equalTo(contentView).inset(padding_body_view)
            make.bottom.equalTo(contentView).offset(-padding_body_view)
        }
    }

    func configure(item: TrackingData) {
        dateLabel.text =  item.startDate.formattedString(.yyyy_M_d)
        startPlaceLabel.text = "\(item.startLocation ?? "")"
        endPlaceLabel.text = "\(item.endLocation ?? "")"
        tripTypeImage.image = UIImage(systemName: item.tripType == .oneWay ? "arrow.down" : "arrow.up.arrow.down")
//        print("configure: \nstart: \(startPlaceLabel.frame.height)\nimage: \(tripTypeImage.frame.height)\nend: \(endPlaceLabel.frame.height)")
    }
}
