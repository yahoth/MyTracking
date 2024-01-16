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
    var mapViewContainer: UIView!
    var mapView: MKMapView!
    var routeLabelView: RouteLabelView!
    var presentMap: (() -> Void)!
    var subscriptions = Set<AnyCancellable>()
    var vm: TrackingResultRouteCellViewModel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTitle(to: "Route")
        setMapViewContainer()
        setMapView()
        setRouteLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind() {
        vm.tempPath?
            .sink { [weak self] _ in
                self?.drawMap()
            }.store(in: &subscriptions)
    }

    func drawMap() {
        vm.drawMap(mapView)
    }

    func configure(start: String, end: String) {
        routeLabelView.startPlaceLabel.text = start
        routeLabelView.endPlaceLabel.text = end
    }

    func setMapViewContainer() {
        mapViewContainer = UIView()
        contentView.addSubview(mapViewContainer)
        mapViewContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding_title_body)
            make.horizontalEdges.equalTo(contentView).inset(padding_body_view)
            make.height.equalTo(contentView.snp.width).multipliedBy(0.8)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapViewContainer.addGestureRecognizer(tapGesture)
    }

    func setMapView() {
        mapView = MKMapView()
        mapView.isUserInteractionEnabled = false

        mapViewContainer.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(mapViewContainer)
        }
    }

    func setRouteLabel() {
        routeLabelView = RouteLabelView()
        contentView.addSubview(routeLabelView)
        routeLabelView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(padding_body_body)
            make.horizontalEdges.equalTo(contentView).inset(padding_body_view)
            make.bottom.equalTo(contentView).inset(padding_body_body)
            make.height.equalTo(60) // label 개당 높이 25, 스택뷰 스페이싱 10
        }
    }

    @objc func mapTapped(_ sender: UITapGestureRecognizer) {
        presentMap()
    }
}
