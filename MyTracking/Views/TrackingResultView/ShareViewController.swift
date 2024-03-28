//
//  ShareViewController.swift
//  MyTracking
//
//  Created by TAEHYOUNG KIM on 3/25/24.
//

import UIKit
import Combine

class ShareViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var startLocation: UILabel!
    @IBOutlet weak var endLocation: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var mapViewImage: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var topSpeed: UILabel!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var topSpeedLabel: UILabel!
    


    @Published var trackingData: TrackingData!
    @Published var image: UIImage!
    var subscriptions = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setCornerStyle()
        bind()
    }

    func bind() {
        $trackingData
            .receive(on: DispatchQueue.main)
            .compactMap{ $0 }
            .sink { [weak self] item in
                self?.configure(item: item)
            }.store(in: &subscriptions)
        $image
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .compactMap{ $0 }
            .sink { [weak self] image in
                self?.mapViewImage.image = image
            }.store(in: &subscriptions)
    }

    func setCornerStyle() {
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
    }

    func configure(item: TrackingData) {
        startLocation.text = item.startLocation
        endLocation.text = item.endLocation

        distanceLabel.text = "Distance".localized()
        averageSpeedLabel.text = "Average Speed".localized()
        altitudeLabel.text = "Altitude".localized()
        topSpeedLabel.text = "Top Speed".localized()

        time.text = (item.speedInfos.first { $0.title == "Time" }?.value ?? 0).timeFormatter

        let unit = SettingManager.shared.unit

        let distanceInfo = item.speedInfos.first { $0.title == "Distance" }
        let averageSpeedInfo = item.speedInfos.first { $0.title == "Average Speed" }
        let topSpeedInfo = item.speedInfos.first { $0.title == "Top Speed" }
        let altitudeInfo = item.speedInfos.first { $0.title == "Altitude" }
        distance.text = "\(String(format: "%.1f", distanceInfo?.value.distanceToSelectedUnit(unit) ?? 0)) \(unit.correspondingDistanceUnit)"

        averageSpeed.text = "\(String(format: "%.0f", averageSpeedInfo?.value.speedToSelectedUnit(unit) ?? 0))\(unit.displayedSpeedUnit)"
        altitude.text = "\(String(format: "%.0f", altitudeInfo?.value.altitudeToSelectedUnit(unit) ?? 0))\(unit.correspondingAltitudeUnit)"

        topSpeed.text = "\(String(format: "%.0f", topSpeedInfo?.value.speedToSelectedUnit(unit) ?? 0))\(unit.displayedSpeedUnit)"
    }
}
