//
//  TrackingResultHeaderView.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/19/23.
//

import UIKit

import SnapKit

class TrackingResultHeaderView: UITableViewHeaderFooterView {

    var headerLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: 20, weight: .bold)
        headerLabel.textColor = .black
        headerLabel.textAlignment = .left
        contentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
