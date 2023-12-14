//
//  TrackingResultCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit

import SnapKit

protocol ConfigurableCell {
    func setTitle(to title: String)
}

class TrackingResultCell: UITableViewCell, ConfigurableCell {

    var titleLabel: UILabel!
    var body: UIView!
    var separator: UIView!

    func setTitle(to title: String) {
        titleLabel.text = title
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        body = UIView()
        body.backgroundColor = .blue
        separator = UIView()
        separator.backgroundColor = .systemGray4

        [titleLabel, body, separator].forEach(self.contentView.addSubview(_:))

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(10)
            make.horizontalEdges.equalTo(contentView).inset(10)
        }

        body.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView).inset(22)
        }

        separator.snp.makeConstraints { make in
            make.bottom.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(2)
        }

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
