//
//  RouteLabelView.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/15/23.
//

import UIKit

import SnapKit

class RouteLabelView: UIView {

    deinit {
        print("routeLabelview Deinit")
    }

    var fromPlaceLabel: UILabel!
    var toPlaceLabel: UILabel!

    var fromLabel: UILabel!
    var toLabel: UILabel!

    var vStackView: UIStackView!

    init(frame: CGRect, isEdit: Bool = false) {
        self.isEdit = isEdit
        super.init(frame: frame)

        setVStack()
        setFromAndToLabel()

        if !isEdit {
            /// EditView가 아닐 경우 장소 레이블, 에딧 버튼 세팅
            setPlaceLabels()
            setEditButton(editButton1, tag: 1)
            setEditButton(editButton2, tag: 2)

            setHStack(label: fromLabel, placeLabel: fromPlaceLabel, editButton: editButton1, tag: 1)
            setHStack(label: toLabel, placeLabel: toPlaceLabel, editButton: editButton2, tag: 2)
        } else {
            setHStack(label: fromLabel, textField: textField1, editButton: editButton1, tag: 1)
            setHStack(label: toLabel, textField: textField2, editButton: editButton2, tag: 2)
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

    let editButton1 = UIButton()
    let editButton2 = UIButton()

    func setEditButton(_ button: UIButton, tag: Int) {
        button.tag = tag
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    var presentEditVC: ((Int) -> Void?)?

    @objc func editButtonTapped(_ sender: UIButton) {
        guard let presentEditVC else { return }

        if sender.tag == 1 {
            presentEditVC(1)
        } else if sender.tag == 2 {
            presentEditVC(2)
        }
    }

    var isEdit: Bool
    var textField1 = UITextField()
    var textField2 = UITextField()


    func setHStack(label: UILabel, placeLabel: UILabel? = nil, textField: UITextField? = nil, editButton: UIButton, tag: Int) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        vStackView.addArrangedSubview(stackView)

        let verticalColoredLine = UIView()
        verticalColoredLine.backgroundColor = tag == 1 ? .green : .red
        verticalColoredLine.snp.makeConstraints { make in
            make.width.equalTo(4)
        }

        if !isEdit {
            [verticalColoredLine, label, placeLabel!, editButton].forEach(stackView.addArrangedSubview(_:))
        } else {
            [verticalColoredLine, label, textField!].forEach(stackView.addArrangedSubview(_:))
        }
    }
}
