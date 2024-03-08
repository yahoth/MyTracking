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
        setNavigationBarItems()
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

    func setNavigationBarItems() {
        navigationItem.title = "Edit"
        let doneItem = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItems = [doneItem]

        let dismissItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissEditVC))
        navigationItem.leftBarButtonItems = [dismissItem]
    }

    @objc func done() {
        if trackingData.startLocation != startPlaceTextField.text || trackingData.endLocation != endPlaceTextField.text {
            RealmManager.shared.update(item: trackingData, start: startPlaceTextField.text, end: endPlaceTextField.text)

            dismiss(animated: true) { [weak self] in
                self?.editChanges?()
            }
        } else {
            dismiss(animated: true)
        }
    }

    @objc func dismissEditVC() {
        dismiss(animated: true)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if startPlaceTextField == textField {
            endPlaceTextField.becomeFirstResponder()
        } else {
            endPlaceTextField.resignFirstResponder()
        }
        return true
    }
}
