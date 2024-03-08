//
//  TrackingResultRouteCellViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/20/23.
//

import Foundation
import MapKit

class TrackingResultRouteCellViewModel: NSObject {
    deinit {
        print("TrackingResultRouteCellViewModel deinit")
    }

    @Published var path: PathInfo

    init(path: PathInfo) {
        self.path = path
    }

    var locationDatas: [LocationDataPerTenMeters] {
        Array(path.locationDatas)
    }

    func drawMap(_ mapView: MKMapView) {
        mapView.delegate = self
        addOverlay(mapView)
        setRegion(mapView)
        addAnnotations(mapView, place: .start)
        addAnnotations(mapView, place: .end)
    }

    func addOverlay(_ mapView: MKMapView) {
        var lastTimestamp: Date?
        var segment: [CLLocationCoordinate2D] = []

        for timedCoordinate in locationDatas {
            if let lastTimestamp = lastTimestamp, timedCoordinate.date.timeIntervalSince(lastTimestamp) > 60 {
                // 시간 차이가 1분을 넘으면, 지금까지 수집한 세그먼트를 오버레이로 추가
                if !segment.isEmpty {
                    let lineDraw = MKPolyline(coordinates: segment, count: segment.count)
                    mapView.addOverlay(lineDraw)
                    segment.removeAll()
                }
            }

            segment.append(timedCoordinate.coordinate)
            lastTimestamp = timedCoordinate.date
        }

        // 마지막 세그먼트 추가
        if !segment.isEmpty {
            let lineDraw = MKPolyline(coordinates: segment, count: segment.count)
            mapView.addOverlay(lineDraw)
        }
    }

    func setRegion(_ mapView: MKMapView) {
        let coordinate: [CLLocationCoordinate2D] = locationDatas.map { $0.coordinate }
        let latitudes = coordinate.map { $0.latitude }
        let longitudes = coordinate.map { $0.longitude }

        let minLat = latitudes.min() ?? 0
        let maxLat = latitudes.max() ?? 0
        let minLon = longitudes.min() ?? 0
        let maxLon = longitudes.max() ?? 0

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 3, longitudeDelta: (maxLon - minLon) * 3)

        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
    }

    enum AnnotationPlace: String {
        case start
        case end
    }

    func addAnnotations(_ mapView: MKMapView, place: AnnotationPlace) {
        guard let coordinate = (place == .start) ? locationDatas.first : locationDatas.last else { return }

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate.coordinate
        annotation.title = place.rawValue
        mapView.addAnnotation(annotation)
    }
}

extension TrackingResultRouteCellViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { return MKOverlayRenderer() }
        let renderer = MKPolylineRenderer(polyline: polyLine)

        renderer.lineWidth = 5
        renderer.alpha = 1.0
        renderer.strokeColor = .black
        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.titleVisibility = .hidden
        annotationView?.glyphText = ""
        setMarkerColorFor(annotation, in: annotationView)

        return annotationView
    }

    func setMarkerColorFor(_ annotation: MKAnnotation, in annotationView: MKMarkerAnnotationView?) {
        annotationView?.markerTintColor = annotation.title == "start" ? .green : .red
    }
}
