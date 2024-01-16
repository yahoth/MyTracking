//
//  TrackingResultViewController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit
import MapKit
import Combine

import SnapKit

class TrackingResultViewController: UIViewController {

    var tableView: UITableView!
    var vm: TrackingResultViewModel!
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Tracking Data"

        setTableView()
        setConstrains()
        if vm.viewType == .modal {
            setDismissButton()
        }
    }

    func setDismissButton() {
        let dismissItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTracking))
        self.navigationItem.rightBarButtonItem = dismissItem
    }

    @objc func doneTracking() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }

    func setTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.dataSource = self
        setTableViewSeparator()
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TrackingResultRouteCell.self, forCellReuseIdentifier: "TrackingResultRouteCell")
        tableView.register(TrackingResultSpeedInfoCell.self, forCellReuseIdentifier: "TrackingResultSpeedInfoCell")

        func setTableViewSeparator() {
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = .brown
            tableView.separatorInset = .init(top: 0, left: padding_body_view, bottom: 0, right: padding_body_view)
        }
    }

    func setConstrains() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

}

extension TrackingResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingResultRouteCell", for: indexPath) as? TrackingResultRouteCell else { return UITableViewCell() }
            let cellVM = TrackingResultRouteCellViewModel(path: vm.path)
            cell.vm = cellVM
            cell.bind()
            cell.presentMap = presentMapDetailView

            Task {
                try await cell.configure(start: self.vm.reverseGeocodeLocation(self.vm.start), end: self.vm.reverseGeocodeLocation(self.vm.end))
            }

            func presentMapDetailView() {
                let vc = TrackingResultMapDetailViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                vc.vm = cellVM
                self.present(nav, animated: true)
            }

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingResultSpeedInfoCell", for: indexPath) as? TrackingResultSpeedInfoCell else { return UITableViewCell() }
            cell.vm = vm
            cell.setCollectionViewConstraints(superViewHeight: view.frame.height)
            return cell
        }

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vm.trackingData.startDate.formattedString(.full) + " ~ " + vm.trackingData.endDate.formattedString(.full)
    }

}

extension TrackingResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension TrackingResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { return MKOverlayRenderer() }
        let renderer = MKPolylineRenderer(polyline: polyLine)

        renderer.lineWidth = 5
        renderer.alpha = 1.0
        renderer.strokeColor = .blue
        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            (annotationView as? MKMarkerAnnotationView)?.glyphTintColor = .black
            (annotationView as? MKMarkerAnnotationView)?.titleVisibility = .hidden

            if annotation.title == "start" {
                (annotationView as? MKMarkerAnnotationView)?.markerTintColor = .green
                (annotationView as? MKMarkerAnnotationView)?.glyphText = "start"

            } else {
                (annotationView as? MKMarkerAnnotationView)?.markerTintColor = .red
                (annotationView as? MKMarkerAnnotationView)?.glyphText = "end"
            }
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("mapViewDidFinishLoadingMap")
    }

    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("mapViewDidFinishRenderingMap: \(fullyRendered)")
    }
}

///Fix
///1. 모든 렌더링이 담기지 않는거
///2. 중지 시킨 부분도 경로로 기록됌

