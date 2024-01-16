//
//  SpeedInfo.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 11/8/23.
//

import Foundation

import RealmSwift

class SpeedInfo: Object {
    @Persisted var value: Double
    @Persisted var unit: String? = nil
    @Persisted var title: String

    convenience init(value: Double, unit: String? = nil, title: String) {
        self.init()
        self.value = value
        self.unit = unit
        self.title = title
    }
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
