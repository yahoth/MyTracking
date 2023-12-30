//
//  HistoryCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/29/23.
//

import UIKit

import SnapKit

class HistoryCell: UITableViewCell {
    var tempLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tempLabel = UILabel()
        tempLabel.font = .systemFont(ofSize: 20)
        tempLabel.textColor = .label
        tempLabel.numberOfLines = 0
        contentView.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: Temp) {
        tempLabel.text = item.str
    }

}
