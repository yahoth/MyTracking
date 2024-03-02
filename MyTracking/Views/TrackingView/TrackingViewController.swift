//
//  TrackingViewController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/7/23.
//

import UIKit
import MapKit
import Combine

import FloatingPanel
import SnapKit


class TrackingViewController: UIViewController, FloatingPanelControllerDelegate {
    var workItem: DispatchWorkItem?
    deinit {
        print("TrackingViewController deinit")
    }
    //View
    var mapView: MKMapView!
    var trackingButton: UIButton!
    var currentSpeedView: CurrentSpeedView!
    var fpc: FloatingPanelController!
    let appTitle = AppTitleLabel(frame: .zero, title: "My\(SettingManager.shared.activityType.rawValue.capitalized)")

    //Model
    var vm: TrackingViewModel!
    var subscriptions = Set<AnyCancellable>()
    var isFirstCall = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        
        currentSpeedView = CurrentSpeedView()
        setLocationTrackingButton()
        setMapView()

        [appTitle, mapView, currentSpeedView, trackingButton].forEach { view.addSubview($0) }

        setFPC()
        setConstraints()

        customizeSurfaceDesign()

        setupChangeUnitButton()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm.startAndPause()
        mapView.userTrackingMode = .followWithHeading
    }

    func setConstraints() {
        appTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(padding_body_view)
            make.bottom.equalTo(currentSpeedView.snp.top).inset(-padding_body_body)
        }

        currentSpeedView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(mapView.snp.top).inset(-padding_body_body)
        }

        mapView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(view.frame.height * 0.4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view).inset(vm.mapViewBottomPadding)
        }

        trackingButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top).inset(5)
            make.leading.equalTo(mapView.snp.leading).inset(5)
            make.size.equalTo(44)
        }
    }

    func setMapView() {
        mapView = MKMapView()
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    func setLocationTrackingButton() {
        trackingButton = UIButton()
        trackingButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        trackingButton.addTarget(self, action: #selector(trackingLocation), for: .touchUpInside)
        trackingButton.backgroundColor = .systemBackground
        trackingButton.layer.cornerRadius = 22
    }

    @objc func trackingLocation() {
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }

    func setFPC() {
        fpc = FloatingPanelController(delegate: self)
        let vc = SpeedInfoPanelViewController()
        vm = TrackingViewModel(fpc: self.fpc)
        vc.vm = vm
        let navigationVC = UINavigationController(rootViewController: vc)
        fpc.set(contentViewController: navigationVC)

        fpc.track(scrollView: vc.collectionView)
        fpc.isRemovalInteractionEnabled = false
        vm.navigationBarHeight = vc.navigationController?.navigationBar.frame.size.height ?? 0
        fpc.layout = MyFloatingPanelLayout(tipInset: vm.navigationBarHeight)
        fpc.addPanel(toParent: self)
    }

    func bind() {
        vm.$totalElapsedTime
            .subscribe(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.currentSpeedView.speedLabel.text = String(format: "%.0f", self?.vm.convertedSpeed ?? 0)
                self?.updateTrackingOverlay()
            }.store(in: &subscriptions)

        vm.$isStopped
            .sink { [weak self] bool in
                if bool {
                    self?.alertWhenStopButtonTapped()
                    self?.vm.endDate = Date()
                }
            }.store(in: &subscriptions)

        vm.$isPaused
            .sink { [weak self] bool in
                if bool {
                    self?.currentSpeedView.speedLabel.text = "0"
                }
            }.store(in: &subscriptions)

        vm.$unitOfSpeed
            .sink { [weak self] unit in
                self?.currentSpeedView.unitButton.setTitle(unit?.displayedSpeedUnit, for: .normal)
            }.store(in: &subscriptions)
    }

    func alertWhenStopButtonTapped() {
        let canSave = vm.totalElapsedTime >= 60
        let message = canSave ? "quit?".localized() : "tooShortToRecord".localized()
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive) { [weak self] _ in
            self?.finishTracking(canSave: canSave)
        })

        alert.addAction(UIAlertAction(title: "No".localized(), style: .cancel))

        present(alert, animated: true)
    }

    func finishTracking(canSave: Bool) {
        if canSave {
            let vc = TrackingResultViewController()

            Task {
                await vc.vm = TrackingResultViewModel(trackingData: self.vm.createTrackingResult(), viewType: .modal)
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }

    }

    private func setupChangeUnitButton() {
        let units = UnitOfSpeed.allCases.map { unit in
            UIAction(title: unit.displayedSpeedUnit) { [weak self] _ in
                self?.vm.updateUnit(unit)
            }
        }

        let menu = UIMenu(title: "Select unit of speed".localized(), options: .displayInline, children: units)
        currentSpeedView.unitButton.menu = menu
    }


    func updateTrackingOverlay() {
        if let points = vm.points {
            let polyline = MKPolyline(coordinates: points, count: points.count)
            mapView.addOverlay(polyline, level: .aboveRoads)
        }
    }

    //FloatingPanelControllerDelegate

    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        vm.state = fpc.state
    }

    func customizeSurfaceDesign() {
        // Create a new appearance.
        let appearance = SurfaceAppearance()

        // Define shadows
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 16
        shadow.spread = 8
        appearance.shadows = [shadow]
        appearance.backgroundColor = .systemBackground

        fpc.surfaceView.appearance = appearance

        fpc.surfaceView.grabberHandlePadding = 4
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    var tipInset: CGFloat

    init(tipInset: CGFloat) {
        self.tipInset = tipInset
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] { [
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.6, edge: .bottom, referenceGuide: .superview),
        .tip: FloatingPanelLayoutAnchor(absoluteInset: tipInset, edge: .bottom, referenceGuide: .safeArea),
        // view가 safeArea + tipInset 만큼 빼꼼해있음
    ] }
}

extension TrackingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if !vm.isStopped {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .black
                renderer.lineWidth = 5
                renderer.alpha = 1
                return renderer
            } else {
                return MKOverlayRenderer()
            }
        } else {
            return MKOverlayRenderer()
        }
    }

    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if isFirstCall {
            isFirstCall = false
            return
        }
        // 이전에 예약된 작업이 있다면 취소
        workItem?.cancel()

        workItem = DispatchWorkItem { [weak self] in
            self?.trackingLocation()
        }

        // 5초 후에 workItem을 실행
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem!)
    }
}
