//
//  EditViewController.swift
//  MyTracking
//
//  Created by TAEHYOUNG KIM on 3/7/24.
//

import UIKit

import SnapKit

class EditViewController: UIViewController {
    deinit {
        print("EditViewController deinit")
    }

    var routeLabelView: RouteLabelView = {
        let view = RouteLabelView(frame: .zero, isEdit: true)
        return view
    }()

    var editChanges: (() -> Void)?

    var startPlaceTextField: UITextField {
        routeLabelView.textField1
    }

    var endPlaceTextField: UITextField {
        routeLabelView.textField2
    }

    var trackingData: TrackingData!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Edit"
        let doneItem = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItems = [doneItem]


        setTextFieldText()
        setTextField()
        setConstraints()
    }

    func setTextField() {
        [startPlaceTextField, endPlaceTextField].forEach {
            $0.font = .systemFont(ofSize: 18, weight: .bold)
            $0.clearButtonMode = .always
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.autocapitalizationType = .none
            $0.delegate = self
        }
    }

    @objc func done() {
        RealmManager.shared.update(item: trackingData, start: startPlaceTextField.text, end: endPlaceTextField.text)

        dismiss(animated: true) { [weak self] in
            self?.editChanges?()
        }
    }

    func setConstraints() {
        view.addSubview(routeLabelView)

        routeLabelView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: padding_body_view, left: padding_body_view, bottom: 0, right: padding_body_view))
        }
    }

    func setTextFieldText() {
        startPlaceTextField.text = trackingData.startLocation
        endPlaceTextField.text = trackingData.endLocation
    }

}

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }

    // 입력을 시작할때 호출 (시작할지 말지를 물어보는 것)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
//        routeLabelView.textfield1.becomeFirstResponder()
        return true
    }

    // 입력이 시작되면 호출 (시점)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }

    // 내용을 삭제할 때 호출 (삭제할지 말지를 물어보는 것) .clearButtonMode과 연관
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("textFieldShouldClear")

        return true
    }

    // 한글자 한글자 입력/지워질때마다 호출 ---> true(입력 허락), false(입력 거부)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("textField")
        return true
    }

    // 엔터키가 눌러졌을때 호출 (동작할지 말지 물어보는 것)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if startPlaceTextField == textField {
            endPlaceTextField.becomeFirstResponder()
        } else {
            endPlaceTextField.resignFirstResponder()
        }
        return true
    }
}
