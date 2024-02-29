//
//  TrackingResultMapDetailViewController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/21/23.
//

import UIKit
import MapKit

import SnapKit

class TrackingResultMapDetailViewController: UIViewController {
    deinit {
        print("TrackingResultMapDetailViewController deinit")
    }

    var vm: TrackingResultRouteCellViewModel!
    var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        vm.drawMap(mapView)
        view.backgroundColor = .systemBackground
        setDismissButton()
    }

    func setMapView() {
        mapView = MKMapView()
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setDismissButton() {
        let dismissItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(dismissMapView))
        self.navigationItem.rightBarButtonItem = dismissItem
    }

    @objc func dismissMapView() {
        self.dismiss(animated: true)
    }
}
