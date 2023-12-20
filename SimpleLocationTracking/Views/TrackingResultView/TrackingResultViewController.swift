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
    var vm: TrackingCompletionViewModel!
    var mapView: MKMapView!
    var imageView: UIImageView!
    var tempMapView: MKMapView!
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Tracking Data"

        setTableView()
        setConstrains()
//        setMapview()
//        setImage()
//        bind()
//        setCaptureMapViewButton()
//        mapView.isUserInteractionEnabled = false
    }

//    func setCaptureMapViewButton() {
//        let captureItem = UIBarButtonItem(image: UIImage(systemName: "play"), style: .plain, target: self, action: #selector(capture))
//        navigationItem.rightBarButtonItem = captureItem
//    }

//    @objc
//    func capture() {
////        vm.image = captureMapAndOverlays(mapView: mapView)
//        view.addSubview(tempMapView)
//        tempMapView.backgroundColor = .black
//        tempMapView.snp.makeConstraints { make in
//            make.width.equalTo(view)
//            make.height.equalTo(view.snp.width).multipliedBy(0.8)
//            make.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
//
//    }
    
//    func setMapview() {
//        mapView = MKMapView()
//        view.addSubview(mapView)
//        mapView.delegate = self
//        mapView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.width.equalTo(view)
//            make.height.equalTo(view.snp.width).multipliedBy(0.8)
//        }
//    }
//
//    func setImage() {
//        imageView = UIImageView()
//        imageView.image = UIImage(named: "map")
//        imageView.backgroundColor = .red
//        view.addSubview(imageView)
//        imageView.snp.makeConstraints { make in
//            make.width.equalTo(view)
//            make.height.equalTo(view.snp.width).multipliedBy(0.8)
//            make.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
//    }

//    func bind() {
//        vm.$path
//            .sink { [unowned self] path in
//                addOverlay(path)
//                setRegion()
//                addAnnotations()
//            }.store(in: &subscriptions)
//
//        vm.$image
//            .receive(on: DispatchQueue.main)
//            .sink { image in
//                if let image {
//                    self.imageView.image = image
//                }
//            }.store(in: &subscriptions)
//    }

//    func addOverlay(_ path: [PathInfo]) {
//        let lineDraw = MKPolyline(coordinates: path.map { $0.coordinate }, count: path.map { $0.coordinate }.count)
//        mapView.addOverlay(lineDraw)
//    }

    func setTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackingResultRouteCell.self, forCellReuseIdentifier: "TrackingResultRouteCell")
        tableView.register(TrackingResultSpeedInfoCell.self, forCellReuseIdentifier: "TrackingResultSpeedInfoCell")
    }

    func setConstrains() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

//    private func setRegion() {
//        let coordinate: [CLLocationCoordinate2D] = vm.path.map { $0.coordinate }
//        let latitudes = coordinate.map { $0.latitude }
//        let longitudes = coordinate.map { $0.longitude }
//
//        let minLat = latitudes.min() ?? 0
//        let maxLat = latitudes.max() ?? 0
//        let minLon = longitudes.min() ?? 0
//        let maxLon = longitudes.max() ?? 0
//
//        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
//        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 6, longitudeDelta: (maxLon - minLon) * 6)
//
//        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
//    }

//    private func addAnnotations() {
//        guard let startCoordinate = vm.path.map({ $0.coordinate }).first,
//        let endCoordinate = vm.path.map({ $0.coordinate }).last else { return }
//
//        let startAnnotation = MKPointAnnotation()
//        startAnnotation.coordinate = startCoordinate
//        startAnnotation.title = "start"
//        let endAnnotation = MKPointAnnotation()
//        endAnnotation.title = "end"
//        endAnnotation.coordinate = endCoordinate
//
//        mapView.addAnnotations([startAnnotation, endAnnotation])
//    }
//
//    func captureMapAndOverlays(mapView: MKMapView) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: mapView.bounds.size)
//        let image = renderer.image { ctx in
//            mapView.drawHierarchy(in: mapView.bounds, afterScreenUpdates: true)
//        }
//        return image
//    }
}

extension TrackingResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingResultRouteCell", for: indexPath) as? TrackingResultRouteCell else { return UITableViewCell() }
            cell.bind(path: vm.path)
            cell.configure()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingResultSpeedInfoCell", for: indexPath) as? TrackingResultSpeedInfoCell else { return UITableViewCell() }
            cell.vm = vm
            cell.setCollectionViewConstraints(superViewHeight: view.frame.height)
            return cell
        }
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
//        imageView.image = captureMapAndOverlays(mapView: mapView)
    }

    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {

        print("mapViewDidFinishRenderingMap: \(fullyRendered)")
//        vm.image = captureMapAndOverlays(mapView: mapView)

        tempMapView = mapView

    }
}

///Fix
///1. 모든 렌더링이 담기지 않는거
///2. 중지 시킨 부분도 경로로 기록됌

