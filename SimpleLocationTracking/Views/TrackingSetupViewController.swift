//
//  TrackingSetupViewController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/28/23.
//

import UIKit

import SnapKit

class TrackingSetupViewController: UIViewController {
    var startTrackingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        startTrackingButton = UIButton()
        startTrackingButton.setTitle("Go Tracking", for: .normal)
        startTrackingButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        startTrackingButton.setTitleColor(.accent, for: .normal)
        startTrackingButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        startTrackingButton.layer.borderWidth = 10
        startTrackingButton.layer.borderColor = UIColor.accent.cgColor
        startTrackingButton.layer.cornerRadius = 50
        view.addSubview(startTrackingButton)
        startTrackingButton.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.centerX.centerY.equalTo(view)
        }
    }

    @objc func start() {
        let vc = TrackingViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
}
