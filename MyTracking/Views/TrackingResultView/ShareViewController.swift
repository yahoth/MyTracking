//
//  ShareViewController.swift
//  MyTracking
//
//  Created by TAEHYOUNG KIM on 3/25/24.
//

import UIKit
import Combine

class ShareViewController: UIViewController {

    @IBOutlet weak var startLocation: UILabel!
    @IBOutlet weak var endLocation: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var mapViewImage: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var topSpeed: UILabel!

    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var bottomContainer: UIStackView!

    @Published var trackingData: TrackingData!
    @Published var image: UIImage!
    var subscriptions = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
//        configure(item: item)
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
        topContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        [topContainer, bottomContainer].forEach {
            $0.layer.cornerRadius = 16
        }
    }

    func configure(item: TrackingData) {
        startLocation.text = item.startLocation
        endLocation.text = item.endLocation
        time.text = item.speedInfos.first(where: { info in
            info.title == "Time"
        })?.value.resultTime
//        mapViewImage.image = UIImage(named: "LaunchScreen")
        distance.text = "123km"
        averageSpeed.text = "122km/h"
        altitude.text = "1500m"
        topSpeed.text = "122km/h"
    }
}
