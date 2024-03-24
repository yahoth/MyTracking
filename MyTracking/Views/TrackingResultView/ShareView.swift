//
//  ShareView.swift
//  MyTracking
//
//  Created by TAEHYOUNG KIM on 3/22/24.
//

import UIKit
import MapKit

@IBDesignable
class ShareView: UIView {


    @IBOutlet weak var startLocation: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var endLocation: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var topSpeedLabel: UILabel!

    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var topSpeed: UILabel!
}
