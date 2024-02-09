//
//  MenuButton.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 2/10/24.
//

import UIKit

import SnapKit

class MenuButton: AnimatedRoundedButton {
    let vStackView = UIStackView()
    let thumbnailImageView = UIImageView()
    let name = UILabel()
    let count = UILabel()
    let selectedItem = UILabel()
    let nameAndCountVStackView = UIStackView()

    override init(frame: CGRect, cornerRadius: AnimatedRoundedButton.CornerRadius? = nil) {
        super.init(frame: frame, cornerRadius: cornerRadius)
        // Set Self(StackView)
        self.backgroundColor = .secondarySystemBackground
        set(vStackView)

        // Set Component
        setImageView()
        set(nameAndCountVStackView)
        setNameLabel()
        setCountLabel()
        setSelectedItemLabel()

        // Layout
        layout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImageView() {
        thumbnailImageView.tintColor = .label
        thumbnailImageView.contentMode = .scaleAspectFit
    }

    func set(_ stackView: UIStackView, spacing: CGFloat? = nil) {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.isUserInteractionEnabled = false

        if let spacing {
            stackView.spacing = spacing
        }
    }

    func setNameLabel() {
        name.font = .systemFont(ofSize: 50, weight: .medium)
        name.textColor = .label
        name.adjustsFontSizeToFitWidth = true
    }

    func setCountLabel() {
        count.font = .systemFont(ofSize: 50)
        count.textColor = .secondaryLabel
        count.adjustsFontSizeToFitWidth = true
    }

    func setSelectedItemLabel() {
        selectedItem.font = .systemFont(ofSize: 50, weight: .medium)
        selectedItem.textColor = .label
        selectedItem.adjustsFontSizeToFitWidth = true
    }

    func layout() {
        self.addSubview(vStackView)
        [name, count].forEach(nameAndCountVStackView.addArrangedSubview(_:))
        [thumbnailImageView, nameAndCountVStackView, selectedItem].forEach(vStackView.addArrangedSubview(_:))

        vStackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(26)
        }

        thumbnailImageView.snp.makeConstraints { make in
            make.size.equalTo(vStackView.snp.width).multipliedBy(0.35)
        }

        name.snp.makeConstraints { make in
            make.height.equalTo(vStackView).multipliedBy(0.15)
        }

        count.snp.makeConstraints { make in
            make.height.equalTo(vStackView).multipliedBy(0.12)
        }

        selectedItem.snp.makeConstraints { make in
            make.height.equalTo(vStackView).multipliedBy(0.15)
        }
    }

    func configure(name: String) {
        self.name.text = name
    }

    func update(image: String, count: String, selectedItem: String) {
        self.thumbnailImageView.image = UIImage(systemName: image)
        self.count.text = count
        self.selectedItem.text = selectedItem
    }
}
