//
//  HistoryCell.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/29/23.
//

import UIKit

import SnapKit


class HistoryCell: UICollectionViewCell {

    /// 최상단 스택 컨테이너
    var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .blue
        return stackView
    }()

    /// 상단 컨테이너 및 UI
    var topContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    var typeImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    var typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "figure.outdoor.cycle")
        return imageView
    }()

    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    func setTopContainer() {
        topStackView.addArrangedSubview(topContainer)
        [typeImageContainer, dateLabel].forEach(topContainer.addSubview(_:))
        typeImageContainer.addSubview(typeImageView)
    }

    // height: 약 82
    func setTopContainerConstraints() {
        typeImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.edges.equalTo(typeImageContainer).inset(10)
        }

        typeImageContainer.snp.makeConstraints { make in
            make.centerY.equalTo(topContainer)
            make.leading.top.equalTo(topContainer).inset(16)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(topContainer)
            make.top.trailing.equalTo(topContainer).inset(16)
            make.leading.equalTo(typeImageContainer.snp.trailing).offset(10)
        }
    }

    /// 중간부 컨테이너
    var bodyContainer = BodyContainer()

    func setMidContainer() {
        topStackView.addArrangedSubview(bodyContainer)
    }

    func setMidContainerConstraints() {
    }

    func setBottmContainer() {
        topStackView.addArrangedSubview(bottomContainer)
    }

    //height: 20
    func setBottomContainerConstraints() {
        bottomContainer.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }



    /// 하단 컨테이너
    var bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        typeImageContainer.layer.cornerRadius = 25
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12 // 원하는 radius 값을 설정하세요.
        contentView.layer.masksToBounds = true

        contentView.addSubview(topStackView)
        setConstraints()
        setTopContainer()
        setTopContainerConstraints()
        setMidContainer()
        setMidContainerConstraints()
        setBottmContainer()
        setBottomContainerConstraints()

        print("init: \(typeImageContainer.frame.width)")
    }

    func setConstraints() {
        topStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }

    func configure(item: TrackingData) {
        dateLabel.text = item.startDate.formattedString(.m_d_h_m)
        bodyContainer.startLocation.text = item.startLocation
        bodyContainer.endLocation.text = item.endLocation
        bodyContainer.time.text = item.speedInfos.first { $0.title == "Time" }?.value.hhmm
        bodyContainer.distance.text = item.speedInfos.first { $0.title == "Distance" }?.value
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

//
//class HistoryCell: UITableViewCell {
//    let startPlaceLabel = UILabel()
//    let endPlaceLabel = UILabel()
//    let tripTypeImage = UIImageView()
//    let dateLabel = UILabel()
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setDateLabel(dateLabel)
//        set(startPlaceLabel)
//        set(endPlaceLabel)
//        set(tripTypeImage)
//        setConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func set(_ tripTypeImage: UIImageView) {
//        tripTypeImage.contentMode = .scaleAspectFit
//        tripTypeImage.frame.size = CGSize(width: 20, height: 20)
//        contentView.addSubview(tripTypeImage)
//    }
//
//    func set(_ label: UILabel) {
//        label.font = .systemFont(ofSize: 20)
//        label.textColor = .label
//        label.numberOfLines = 1
//        label.textAlignment = .center
////        label.adjustsFontSizeToFitWidth = true
////        label.minimumScaleFactor = 0.85
////        label.lineBreakMode = .byTruncatingTail
////        label.setContentCompressionResistancePriority(.required, for: .vertical)
//        contentView.addSubview(label)
//    }
//
//    func setDateLabel(_ label: UILabel) {
//        label.font = .systemFont(ofSize: 20)
//        label.textColor = .label
//        label.numberOfLines = 1
//        label.textAlignment = .left
//        contentView.addSubview(label)
//    }
//
//    func setConstraints() {
//        dateLabel.snp.makeConstraints { make in
//            make.top.equalTo(contentView).inset(padding_body_view)
//            make.height.equalTo(20)
//            make.horizontalEdges.equalTo(contentView).inset(padding_body_view)
//        }
//
//        startPlaceLabel.snp.makeConstraints { make in
//            make.top.equalTo(dateLabel.snp.bottom).offset(padding_body_view)
//            make.height.equalTo(20)
//            make.horizontalEdges.equalTo(contentView).inset(padding_body_view)
//        }
//
//        tripTypeImage.snp.makeConstraints { make in
//            make.top.equalTo(startPlaceLabel.snp.bottom).offset(padding_body_body)
//            make.centerX.equalTo(contentView).inset(padding_body_view)
//        }
//
//        endPlaceLabel.snp.makeConstraints { make in
//            make.top.equalTo(tripTypeImage.snp.bottom).offset(padding_body_body)
//            make.height.equalTo(20)
//            make.horizontalEdges.equalTo(contentView).inset(padding_body_view)
//            make.bottom.equalTo(contentView).inset(padding_body_view)
//        }
//    }
//
//    func configure(item: TrackingData) {
//        dateLabel.text =  item.startDate.formattedString(.m_d_h_m)
//        startPlaceLabel.text = "\(item.startLocation ?? "")"
//        endPlaceLabel.text = "\(item.endLocation ?? "")"
//        tripTypeImage.image = UIImage(systemName: item.tripType == .oneWay ? "arrow.down" : "arrow.up.arrow.down")
//    }
//}
