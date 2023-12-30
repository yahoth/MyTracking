//
//  HistoryCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/29/23.
//

import UIKit

import SnapKit

class HistoryCell: UITableViewCell {
    var timeLabel = UILabel()
    var placeLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        set(timeLabel)
        set(placeLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(_ label: UILabel) {
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 0
        contentView.addSubview(label)
    }

    func setConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
        }

        placeLabel.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(contentView)
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
        }
    }

    func configure(item: TrackingData) {
        timeLabel.text = DateFormatter.localizedString(from: item.startDate, dateStyle: .short, timeStyle: .short)
        placeLabel.text = "\(String(describing: item.startLocation)) -> \(String(describing: item.endLocation))"
    }
}
