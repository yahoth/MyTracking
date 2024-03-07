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
    deinit {
        print("TrackingResultViewController deinit")
    }

    var tableView: UITableView!
    var vm: TrackingResultViewModel!
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = vm.trackingData.startDate.formattedString(.mmmdEEE)

        setTableView()
        setConstrains()
        if vm.viewType == .modal {
            setDismissButton()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func setDismissButton() {
        let dismissItem = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(doneTracking))
        self.navigationItem.rightBarButtonItem = dismissItem
    }

    @objc func doneTracking() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }

    func setTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        setTableViewSeparator()
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TrackingResultPeriodCell.self, forCellReuseIdentifier: "TrackingResultPeriodCell")
        tableView.register(TrackingResultRouteCell.self, forCellReuseIdentifier: "TrackingResultRouteCell")
        tableView.register(TrackingResultSpeedInfoCell.self, forCellReuseIdentifier: "TrackingResultSpeedInfoCell")

        func setTableViewSeparator() {
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = .label
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
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingResultPeriodCell", for: indexPath) as? TrackingResultPeriodCell else { return UITableViewCell() }
            cell.configure(start: self.vm.trackingData.startDate, end: self.vm.trackingData.endDate)
            cell.selectionStyle = .none
            return cell

        } else if indexPath.row  == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingResultRouteCell", for: indexPath) as? TrackingResultRouteCell else { return UITableViewCell() }
            let cellVM = TrackingResultRouteCellViewModel(path: self.vm.path)
            cell.vm = cellVM
            cell.bind()
            cell.onMapTap = { [weak self] in

                    let vc = TrackingResultMapDetailViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    vc.vm = cellVM
                    self?.present(nav, animated: true)
            }

            cell.selectionStyle = .none

            let present = { [weak self] in
                let vc = EditViewController()
                vc.trackingData = self?.vm.trackingData
                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true)
            }

            if vm.viewType == .modal {
                Task { [weak self]  in
                    await cell.configure(start: self?.vm.reverseGeocodeLocation(self?.vm.start ?? CLLocationCoordinate2D()), end: self?.vm.reverseGeocodeLocation(self?.vm.end ?? CLLocationCoordinate2D()), present: present)
                }
            } else {
                cell.configure(start: vm.trackingData.startLocation, end: vm.trackingData.endLocation, present: present)
            }
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingResultSpeedInfoCell", for: indexPath) as? TrackingResultSpeedInfoCell else { return UITableViewCell() }
            cell.vm = self.vm
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension TrackingResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("첫 번째 셀이 클릭되었습니다.")
        case 1:
            print("두 번째 셀이 클릭되었습니다.")
        default:
            print("\(indexPath.row + 1)번째 셀이 클릭되었습니다.")
        }
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
