//
//  SpeedInfo.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/8/23.
//

import Foundation

struct SpeedInfo {
    let value: Double
    let unit: String?
    let title: String
}

extension SpeedInfo {
    static let mocks = [
        SpeedInfo(value: 10111111, unit: "km/h", title: "Average Speed"),
        SpeedInfo(value: 15, unit: "km/h", title: "Top Speed"),
        SpeedInfo(value: 0, unit: nil, title: "Time"),
        SpeedInfo(value: 12, unit: "m", title: "Altitude"),
        SpeedInfo(value: 12, unit: "m", title: "Current Altitude"),
        SpeedInfo(value: 1.5, unit: "km", title: "Distance"),
    ]
}

/// 저장해야할 데이터
///
/// 스피드들(속도변화추이)
/// 좌표들
/// 탑스피드(스피드에서 뽑을수있음)
/// 평균속도
/// 고도
/// 거리
/// 총시간, 출발시간, 도착시간, 휴식시간
/// 여행타입(편도, 왕복)
/// 출발지, 도착지
