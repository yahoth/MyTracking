//
//  RouteLabelView.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/15/23.
//

import UIKit

import SnapKit

class RouteLabelView: UIView {

    var fromPlaceLabel: UILabel!
    var toPlaceLabel: UILabel!

    var fromLabel: UILabel!
    var toLabel: UILabel!

    var vStackView: UIStackView!

    let editButton1 = UIButton()
    let editButton2 = UIButton()

    var presentEditVC: (() -> Void?)?

    init(frame: CGRect, isEdit: Bool = false) {
        self.isEdit = isEdit
        super.init(frame: frame)
        setFromAndToLabel()

        if !isEdit {
            setPlaceLabels()
        }

        [editButton1, editButton2].forEach(setEditButton(_:))

        setVStack()
        // setHStack
        if !isEdit {
            set(mark: fromLabel, label: fromPlaceLabel, button: editButton1, idx: 0)
            set(mark: toLabel, label: toPlaceLabel, button: editButton2, idx: 1)
        } else {
            set(mark: fromLabel, button: editButton1, idx: 0, textField: textfield1)
            set(mark: toLabel, button: editButton2, idx: 1, textField: textfield2)
        }
        setConstraints()


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setPlaceLabels() {
        fromPlaceLabel = UILabel()
        toPlaceLabel = UILabel()
        [fromPlaceLabel, toPlaceLabel].forEach { label in
            label.font = .systemFont(ofSize: 18, weight: .semibold)
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 0
            label.allowsDefaultTighteningForTruncation = true
            label.minimumScaleFactor = 0.8
            label.textAlignment = .left
        }
    }

    func setFromAndToLabel() {
        fromLabel = UILabel()
        toLabel = UILabel()

        fromLabel.text = "From"
        toLabel.text = "To"

        [fromLabel, toLabel].forEach {
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.textColor = .gray
        }
    }

    func setVStack() {
        vStackView = UIStackView()
        self.addSubview(vStackView)
        vStackView.axis = .vertical
        vStackView.spacing = padding_body_body
        vStackView.alignment = .fill
        vStackView.distribution = .fill
    }

    func setConstraints() {
        vStackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        [editButton1, editButton2].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(44)
            }
        }
        [fromLabel, toLabel].forEach{
            $0.snp.makeConstraints { make in
                make.width.equalTo(44)
            }
        }
    }

    func setEditButton(_ button: UIButton) {
        button.setImage(UIImage(named: "edit3"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    @objc func editButtonTapped() {
        print("editButtonTapped")
        guard let presentEditVC else { return }
        presentEditVC()
    }

    var isEdit: Bool
    var textfield1 = UITextField()
    var textfield2 = UITextField()


    func set(mark: UILabel, label: UILabel? = nil, button: UIButton, idx: Int, textField: UITextField? = nil) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        vStackView.addArrangedSubview(stackView)

        let container = UIView()
        container.backgroundColor = idx == 0 ? .green : .red
        container.snp.makeConstraints { make in
            make.width.equalTo(4)
        }

        if !isEdit {
            [container, mark, label!, button].forEach(stackView.addArrangedSubview(_:))
        } else {
            [container, mark, textField!].forEach(stackView.addArrangedSubview(_:))
        }
    }
}
