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
        startTrackingButton.setTitleColor(.accent, for: .normal)
        startTrackingButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        view.addSubview(startTrackingButton)
        startTrackingButton.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

    @objc func start() {
        let vc = TrackingViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
}
