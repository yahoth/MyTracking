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
    var vm: TrackingSetupViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        vm = TrackingSetupViewModel()
        startTrackingButton = UIButton()
        startTrackingButton.setTitle("Go Tracking", for: .normal)
        startTrackingButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        startTrackingButton.setTitleColor(.accent, for: .normal)
        startTrackingButton.addTarget(self, action: #selector(goTrackingButtonTapped), for: .touchUpInside)
        startTrackingButton.layer.borderWidth = 10
        startTrackingButton.layer.borderColor = UIColor.accent.cgColor
        startTrackingButton.layer.cornerRadius = 50
        view.addSubview(startTrackingButton)
        startTrackingButton.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.centerX.centerY.equalTo(view)
        }
    }

    @objc func goTrackingButtonTapped() {

        vm.goTrackingButtonTapped(authorized: startTracking, denied: alertWhenPermissionStatusIsRejected)
    }

    func alertWhenPermissionStatusIsRejected() {
        let title = "위치 정보 권한 요청"
        let message = "이 서비스는 위치 정보가 필요합니다. '확인'을 눌러 위치 정보 권한을 변경해주세요."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "확인", style: .default) { (_) -> Void in
            guard let appSettings = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }

        alert.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }



    func startTracking() {
        let vc = TrackingViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
}
