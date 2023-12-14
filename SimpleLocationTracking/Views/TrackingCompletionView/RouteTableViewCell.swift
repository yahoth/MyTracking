//
//  RouteCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit

import SnapKit

class RouteTableViewCell: TrackingResultCell {

    var tempLabel: UILabel!
    var routeImageView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTitle(to: "Route")
        setRouteImage()
        addLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabel() {
        tempLabel = UILabel()
        tempLabel.text = "temp"
        body.addSubview(tempLabel)

        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(routeImageView.snp.bottom)
            make.horizontalEdges.equalTo(body)
            make.bottom.equalTo(body)
        }
    }

    func setRouteImage() {
        routeImageView = UIImageView()
        body.addSubview(routeImageView)
        routeImageView.snp.makeConstraints { make in
            make.top.equalTo(body)
            make.horizontalEdges.equalTo(body)
            make.height.equalTo(body.snp.width)
        }
    }

    func configure(/*_ data: TravelData*/) {
        routeImageView.image = UIImage(named: "map")
    }
}
