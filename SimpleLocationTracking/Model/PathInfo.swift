//
//  PathInfo.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/20/23.
//

import Foundation
import CoreLocation

import RealmSwift

class PathInfo: Object {
    @Persisted var locationDatas: List<LocationDataPerTenMeters>
    @Persisted var speedsAndAltitudes: List<SpeedAndAltitudePerSeconds>

    convenience init(locationDatas: [LocationDataPerTenMeters], speedsAndAltitudes: [SpeedAndAltitudePerSeconds]) {
        self.init()
        self.locationDatas.append(objectsIn: locationDatas)
        self.speedsAndAltitudes.append(objectsIn: speedsAndAltitudes)
    }
}

//extension PathInfo {
//    func filtered() -> [SpeedAndAltitudePerSeconds] {
//        let data = self.speedsAndAltitudes
//        let count = data.count
//
//        if count <= 100 {
//            return Array(data)
//        } else {
//            /// 101
//            /// 111
//            /// 121
//            /// 151
//            /// 181
//            /// 199
//            let value = count / 100 // 1
//            let remained = count % 100 // 1, 11, 21, 99
//            var result: [SpeedAndAltitudePerSeconds] = []
//
//            for i in 1...count {
//                if i % (count / remained) == 0 {
//
//                } else {
//                    result.append(data[i-1])
//                }
//            }
//            /// count = 111이다.
//            /// 11번 두개로 만들고, 89번 1개로 만든다.
//            /// 111 / 11 = 10 번 들어가니까
//            /// 10의 배수마다 넣어주면 된다. 10, 20, 30, 40 ... 110 총 11번
//            ///
//            /// count = 199
//            /// 99번 2개로 만들고, 1개를 1번 만든다.
//            /// 199 / 99 = 2번 들어가니까
//            /// 2의 배수마다 넣어준다. 2, 4, 6, 8, ...196, 198
//            ///
//            /// count = 122
//            /// 22번 두개로 만들고, 78번 1개로 만든다.
//            /// 122 / 22 = 5번 들어가니까
//            /// 5의 배수마다 5, 10, 15, 20 ... 100, 105, 110, 115, 120
//            /// var 남은횟수 = 22
//            /// if 남은횟수 > 0 ? if i % 5 == 0
//            /// 마지막에 남은 횟수 -1
//            ///
//            /// count = 123
//            /// 23번 두개로 만들고 77번 1개로 만든다.
//            /// 123 / 23 = 5번 들어가니까
//            /// 5의 배수마다 넣어준다.
//
//
//            /// 200
//            /// 201
//            /// 261
//            /// 291
//            print(result.count)
//            return result
//        }
//    }
//}

class LocationDataPerTenMeters: Object {
    @Persisted var coordinate: CLLocationCoordinate2D
    @Persisted var date: Date

    convenience init(coordinate: CLLocationCoordinate2D, date: Date) {
        self.init()
        self.coordinate = coordinate
        self.date = date
    }
}

class SpeedAndAltitudePerSeconds: Object {
    @Persisted var speed: Double
    @Persisted var altitude: Double
    @Persisted var date: Date

   convenience init(speed: Double, altitude: Double, date: Date) {
       self.init()
        self.speed = speed
       self.altitude = altitude
        self.date = date
    }
}

extension SpeedAndAltitudePerSeconds {
}
