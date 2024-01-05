//
//  HistoryCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/29/23.
//

import UIKit

import SnapKit

class HistoryCell: UITableViewCell {
//    var timeLabel = UILabel()
    let startPlaceLabel = UILabel()
    let endPlaceLabel = UILabel()
    let tripTypeImage = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        set(timeLabel)
        set(startPlaceLabel)
        set(endPlaceLabel)
        set(tripTypeImage)
        setConstraints()
        print("start: \(startPlaceLabel.frame.height)")
        print("image: \(tripTypeImage.frame.height)")
        print("end: \(endPlaceLabel.frame.height)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(_ tripTypeImage: UIImageView) {
        tripTypeImage.frame.size = CGSize(width: 20, height: 20)
        tripTypeImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tripTypeImage)
    }

    func set(_ label: UILabel) {
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
    }

    func setConstraints() {
        startPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.height.greaterThanOrEqualTo(20)
            make.horizontalEdges.equalTo(contentView)
        }

        tripTypeImage.snp.makeConstraints { make in
            make.top.equalTo(startPlaceLabel.snp.bottom)
            make.height.equalTo(20)
            make.centerX.equalTo(contentView)
        }

        endPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(tripTypeImage.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.height.greaterThanOrEqualTo(20)
            make.bottom.equalTo(contentView)
        }
    }

    func configure(item: TrackingData) {
//        timeLabel.text = DateFormatter.localizedString(from: item.startDate, dateStyle: .short, timeStyle: .short)
        startPlaceLabel.text = "\(item.startLocation ?? "")"
        endPlaceLabel.text = "\(item.endLocation ?? "")"
        tripTypeImage.image = UIImage(systemName: item.tripType == .oneWay ? "arrow.down" : "arrow.up.arrow.down")
    }
}
