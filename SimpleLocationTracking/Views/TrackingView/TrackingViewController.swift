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

        [mapView, currentSpeedView, trackingButton].forEach { view.addSubview($0) }
        setConstraints()

        setFPC()
        customizeSurfaceDesign()

        bind()
    }

    func setConstraints() {
        currentSpeedView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }

        mapView.snp.makeConstraints { make in
            make.top.equalTo(currentSpeedView.snp.bottom)
            make.horizontalEdges.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(navigationController?.navigationBar.frame.height ?? 0)
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
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserLocation = true
        mapView.delegate = self
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

        fpc.layout = MyFloatingPanelLayout(tipInset: vc.navigationController?.navigationBar.frame.size.height ?? 0)
        fpc.addPanel(toParent: self)
    }

    func bind() {
        vm.$totalElapsedTime
            .subscribe(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.currentSpeedView.speedLabel.text = String(format: "%.0f", self?.vm.speed ?? 0)
                self?.updateTrackingOverlay()
            }.store(in: &subscriptions)

        vm.$isStopped
            .sink { [weak self] bool in
                if bool {
                    let vc = TrackingResultViewController()

                    Task { [weak self] in
                        await vc.vm = TrackingResultViewModel(trackingData: self?.vm.createTrackingResult() ?? TrackingData(), viewType: .modal)
                        let navigationController = UINavigationController(rootViewController: vc)
                        navigationController.modalPresentationStyle = .fullScreen
                        self?.present(navigationController, animated: true)
                    }
                }
            }.store(in: &subscriptions)

        vm.$isPaused
            .sink { [weak self] bool in
                if bool {
                    self?.currentSpeedView.speedLabel.text = "0"
                }
            }.store(in: &subscriptions)
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
