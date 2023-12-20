//
//  TrackingResultRouteCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit
import Combine
import MapKit

import SnapKit

class TrackingResultRouteCell: BaseTrackingResultCell {
    var routeImageView: UIImageView!
    var mapView: MKMapView!
    var routeLabelView: RouteLabelView!
    var subscriptions = Set<AnyCancellable>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTitle(to: "Route")
        setMapview()
        setRouteLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(path: [PathInfo]) {
        addOverlay(path)
        setRegion(path)
        addAnnotations(path)
    }

    func configure(start: String, end: String) {
        routeLabelView.startPlaceLabel.text = start
        routeLabelView.endPlaceLabel.text = end
    }

    func setRouteLabel() {
        routeLabelView = RouteLabelView()
        body.addSubview(routeLabelView)
        routeLabelView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.horizontalEdges.equalTo(body)
            make.bottom.equalTo(body)
            make.height.equalTo(80)
        }
    }

    func setMapview() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        body.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(body)
            make.horizontalEdges.equalTo(body)
            make.height.equalTo(body.snp.width).multipliedBy(0.8)
        }
    }

    func addOverlay(_ path: [PathInfo]) {
        let lineDraw = MKPolyline(coordinates: path.map { $0.coordinate }, count: path.map { $0.coordinate }.count)
        mapView.addOverlay(lineDraw)
    }

    private func setRegion(_ path: [PathInfo]) {
        let coordinate: [CLLocationCoordinate2D] = path.map { $0.coordinate }
        let latitudes = coordinate.map { $0.latitude }
        let longitudes = coordinate.map { $0.longitude }

        let minLat = latitudes.min() ?? 0
        let maxLat = latitudes.max() ?? 0
        let minLon = longitudes.min() ?? 0
        let maxLon = longitudes.max() ?? 0

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 4, longitudeDelta: (maxLon - minLon) * 4)

        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
    }

    private func addAnnotations(_ path: [PathInfo]) {
        guard let startCoordinate = path.map({ $0.coordinate }).first,
        let endCoordinate = path.map({ $0.coordinate }).last else { return }

        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = startCoordinate
        startAnnotation.title = "start"
        let endAnnotation = MKPointAnnotation()
        endAnnotation.title = "end"
        endAnnotation.coordinate = endCoordinate

        mapView.addAnnotations([startAnnotation, endAnnotation])
    }
}

extension TrackingResultRouteCell: MKMapViewDelegate {
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
//
//    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
//        print("mapViewDidFinishLoadingMap")
//    }
//
//    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
//
//        print("mapViewDidFinishRenderingMap: \(fullyRendered)")
//    }
}
