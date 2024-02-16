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

    let modeMenuButton: MenuButton = {
        let button = MenuButton(frame: .zero, cornerRadius: .rounded)
        button.configure(name: "Travel Mode", count: "\(ActivicyType.allCases.count) modes")
        button.update(image: "car", selectedItem: "Car")
        return button
    }()

    let unitMenuButton: MenuButton = {
        let button = MenuButton(frame: .zero, cornerRadius: .rounded)
        button.configure(name: "Speed Unit", count: "\(UnitOfSpeed.allCases.count) units")
        button.update(image: "speed", selectedItem: "KM/H")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        vm = TrackingSetupViewModel()

        setStartButton()
        setUnitMenu()
        setModeMenu()
        setConstraints()

        bind()
    }

    func bind() {
        vm.$status
            .compactMap { $0 }
            .sink { [weak self] status in
                guard let self else { return }
                self.vm.goTrackingButtonTapped(status: status, authorized: self.startTracking, denied: self.alertWhenPermissionStatusIsRejected)
            }.store(in: &subscriptions)

        vm.settingManager.$unit
            .receive(on: DispatchQueue.main)
            .sink { [weak self] unit in
                self?.unitMenuButton.update(image: "speed", selectedItem: unit.displayedSpeedUnit)
            }.store(in: &subscriptions)

        vm.settingManager.$activityType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mode in
                self?.modeMenuButton.update(image: mode.image, selectedItem: mode.rawValue.capitalized)
            }.store(in: &subscriptions)
    }

    func setUnitMenu() {
        let menu = UnitOfSpeed.allCases.map { [weak self] unit in
            UIAction(title: unit.displayedSpeedUnit) { _ in
                self?.vm.settingManager.updateUnit(unit)
            }
        }
        unitMenuButton.menu = UIMenu(title: "Select unit of speed", children: menu)
        unitMenuButton.showsMenuAsPrimaryAction = true
    }

    func setModeMenu() {
        let menu = ActivicyType.allCases.map { [weak self] mode in
            UIAction(title: mode.rawValue.capitalized, image: UIImage(named: mode.image)) { _ in
                self?.vm.settingManager.updateActivityType(mode)
            }
        }
        modeMenuButton.menu = UIMenu(title: "Select mode", children: menu)
        modeMenuButton.showsMenuAsPrimaryAction = true
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
