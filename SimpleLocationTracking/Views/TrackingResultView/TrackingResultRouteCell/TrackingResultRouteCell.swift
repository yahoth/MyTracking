//
//  TrackingResultRouteCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/14/23.
//

import UIKit

import SnapKit

class TrackingResultRouteCell: BaseTrackingResultCell {
    var routeImageView: UIImageView!
    var routeLabelView: RouteLabelView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTitle(to: "Route")
        setRouteImage()
        setRouteLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRouteImage() {
        routeImageView = UIImageView()
        body.addSubview(routeImageView)
        routeImageView.snp.makeConstraints { make in
            make.top.equalTo(body)
            make.horizontalEdges.equalTo(body)
            make.height.equalTo(body.snp.width).multipliedBy(0.8)
        }
    }

    func setRouteLabel() {
        routeLabelView = RouteLabelView()
        body.addSubview(routeLabelView)
        routeLabelView.snp.makeConstraints { make in
            make.top.equalTo(routeImageView.snp.bottom)
            make.horizontalEdges.equalTo(body)
            make.bottom.equalTo(body)
            make.height.equalTo(80)
        }
    }

    func configure(/*_ data: TravelData*/) {
        routeImageView.image = UIImage(named: "map")
        routeLabelView.startPlaceLabel.text = "인천광역시 부평구 주부토로 193"
        routeLabelView.endPlaceLabel.text = "서울특별시 영등포구 여의동로 330"
    }
}
