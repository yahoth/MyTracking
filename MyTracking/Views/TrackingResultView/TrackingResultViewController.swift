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
        setNavigationBarButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func setNavigationBarButton() {
        let shareItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareHistory))
        if vm.viewType == .modal {
            let dismissItem = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(doneTracking))
            self.navigationItem.rightBarButtonItems = [shareItem, dismissItem]
        } else {
            self.navigationItem.rightBarButtonItems = [shareItem]
        }
    }

    @objc func shareHistory() {
        print(vm.trackingData)
        let indexPath = IndexPath(row: 1, section: 0)
        let image = captureMapViewInCell(tableView: tableView, at: indexPath)
        let sb = UIStoryboard(name: "Share", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        vc.trackingData = vm.trackingData
        vc.image = image
        present(vc, animated: true)
    }

    @objc func doneTracking() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }

    func captureMapViewInCell(tableView: UITableView, at indexPath: IndexPath) -> UIImage? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TrackingResultRouteCell else {
            return nil
        }

        return captureMapView(cell.mapView)
    }


    func captureMapView(_ mapView: MKMapView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: mapView.bounds.size)
        let image = renderer.image { ctx in
//            mapView.layer.render(in: ctx.cgContext)
            mapView.drawHierarchy(in: mapView.bounds, afterScreenUpdates: true)
        }
        return image
    }

    func shareImage(_ image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        // iPad에서는 popover로 표시해야 하므로 anchor를 설정
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view // 또는 버튼 등 특정 뷰를 기준으로 설정
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = [] // 화살표 방향 없음
        }
        self.present(activityViewController, animated: true, completion: nil)
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

            let editChanges: () -> Void = { [weak self, weak cell] in
                cell?.configure(start: self?.vm.trackingData.startLocation, end: self?.vm.trackingData.endLocation)
            }

            let presentEditVC = { [weak self] (tag: Int) in
                let vc = EditViewController()

                vc.trackingData = self?.vm.trackingData
                let nav = UINavigationController(rootViewController: vc)

                if tag == 1 {
                    vc.startPlaceTextField.becomeFirstResponder()
                } else {
                    vc.endPlaceTextField.becomeFirstResponder()
                }

                vc.editChanges = editChanges
                self?.present(nav, animated: true)
            }

            cell.configure(start: vm.trackingData.startLocation, end: vm.trackingData.endLocation)
            cell.configureClosure(presentEditVC: presentEditVC)

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
