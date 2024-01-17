//
//  TrackingResultRouteCellViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/20/23.
//

import Foundation
import CoreLocation
import MapKit
import Combine

import RealmSwift

class TrackingResultRouteCellViewModel: NSObject {
    deinit {
        print("TrackingResultRouteCellViewModel deinit")
    }

    @Published var path: List<PathInfo>
//    weak var tempPath: CurrentValueSubject<List<PathInfo>, Never>?

    init(path: List<PathInfo>) {
        self.path = path
//        self.tempPath?.send(path ?? List<PathInfo>())
    }

    var coordinates: [CLLocationCoordinate2D] {
        path.map { $0.coordinate }
    }

    func drawMap(_ mapView: MKMapView) {
        mapView.delegate = self
        addOverlay(mapView)
        setRegion(mapView)
        addAnnotations(mapView, place: .start)
        addAnnotations(mapView, place: .end)
    }

    func addOverlay(_ mapView: MKMapView) {
        let lineDraw = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(lineDraw)
    }

    func setRegion(_ mapView: MKMapView) {
        let coordinate: [CLLocationCoordinate2D] = coordinates
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
        guard let coordinate = (place == .start) ? coordinates.first : coordinates.last else { return }

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
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
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)

            (annotationView as? MKMarkerAnnotationView)?.titleVisibility = .hidden

            setGlyphFor(annotation)
            setMarkerColorFor(annotation)

        } else {
            annotationView?.annotation = annotation
        }

        return annotationView

        func setMarkerColorFor(_ annotation: MKAnnotation) {
            (annotationView as? MKMarkerAnnotationView)?.markerTintColor = annotation.title == "start" ? .green : .red
        }

        func setGlyphFor(_ annotation: MKAnnotation) {
            (annotationView as? MKMarkerAnnotationView)?.glyphText = annotation.title == "start" ? "start" : "end"
            (annotationView as? MKMarkerAnnotationView)?.glyphTintColor = .black
        }
    }
}
