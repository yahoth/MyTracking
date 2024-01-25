//
//  HistoryHeaderView.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 1/26/24.
//

import UIKit

import SnapKit

class HistoryHeaderView: UICollectionReusableView {
    static let identifier = "HistoryHeaderView"

    let title: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.addSubview(title)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setConstraints() {
        title.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(16)
        }
    }

    func configure(with text: String) {
        title.text = text
    }

}
