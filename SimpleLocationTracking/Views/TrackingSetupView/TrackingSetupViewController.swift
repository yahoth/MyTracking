//
//  TrackingSetupViewController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/28/23.
//

import UIKit
import Combine

import SnapKit

class TrackingSetupViewController: UIViewController {
    var vm: TrackingSetupViewModel!
    var subscriptions = Set<AnyCancellable>()

    var startTrackingButton: AnimatedRoundedButton!

    let unitMenuButton: MenuButton = {
        let button = MenuButton(frame: .zero, cornerRadius: .rounded)
        button.configure(name: "Speed Unit")
        button.update(image: "gauge.with.dots.needle.67percent", count: "4 units", selectedItem: "KM/H")
        return button
    }()

    let modeMenuButton: MenuButton = {
        let button = MenuButton(frame: .zero, cornerRadius: .rounded)
        button.configure(name: "Travel Mode")
        button.update(image: "car", count: "6 modes", selectedItem: "Car")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        vm = TrackingSetupViewModel()

        setStartButton()
        setConstraints()

        bind()
    }

    func setStartButton() {
        startTrackingButton = AnimatedRoundedButton(frame: .zero, cornerRadius: .rounded)
        let view = StartButtonView()
        startTrackingButton.addSubview(view)
        startTrackingButton.backgroundColor = .secondarySystemBackground
        startTrackingButton.addTarget(self, action: #selector(goTrackingButtonTapped), for: .touchUpInside)
        view.snp.makeConstraints { make in
            make.edges.equalTo(startTrackingButton).inset(UIEdgeInsets(top: 10, left: 26, bottom: 10, right: 26))
        }
    }

    func setConstraints() {
        view.addSubview(startTrackingButton)
        startTrackingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(view.snp.height).multipliedBy(0.15)
        }

        let stackView = UIStackView(arrangedSubviews: [modeMenuButton, unitMenuButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(startTrackingButton.snp.top).inset(-16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
        }
    }


    func bind() {
        vm.$status
            .compactMap { $0 }
            .sink { [weak self] status in
                guard let self else { return }
                self.vm.goTrackingButtonTapped(status: status, authorized: self.startTracking, denied: self.alertWhenPermissionStatusIsRejected)
            }.store(in: &subscriptions)
    }


    @objc func goTrackingButtonTapped() {
        if vm.locationManager == nil {
            vm.locationManager = LocationManager()
            vm.bind()
        } else {
            guard let status = vm.status else { return }
            vm.goTrackingButtonTapped(status: status, authorized: startTracking, denied: alertWhenPermissionStatusIsRejected)
        }
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
