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
    @Persisted var locationDatas: List<TimedLocationData>
    @Persisted var speeds: List<TimedSpeedData>

    convenience init(locationDatas: [TimedLocationData], speeds: [TimedSpeedData]) {
        self.init()
        self.locationDatas.append(objectsIn: locationDatas)
        self.speeds.append(objectsIn: speeds)
    }
}

extension PathInfo {
    var altitudeStatisticsData: [(date: Date, altitude: Double)] {
        if locationDatas.count <= 100 {

            return locationDatas.map{ ($0.date, $0.altitude) }
        } else {
            /// 1000개일때, 10개씩
            /// 10000개일때 100개씩
        return calculateMedianAltitude(data: locationDatas)
        }
    }

    var speedStatisticsData: [TimedSpeedData] {
        if speeds.count <= 100 {

            return Array(speeds)
        } else {
            /// 1000개일때, 10개씩
            /// 10000개일때 100개씩
        return calculateMedianSpeed(data: speeds)
        }
    }

    func calculateMedianSpeed(data: List<TimedSpeedData>) -> [TimedSpeedData] {
        let groupSize = data.count / 100
        var result: [TimedSpeedData] = []

        for i in 0..<100 {
            let groupStartIndex = i * groupSize
            let groupEndIndex = min((i+1) * groupSize, data.count)
            let group = Array(data[groupStartIndex..<groupEndIndex])

            let sortedGroup = group.sorted { $0.speed < $1.speed }
            let middleIndex = sortedGroup.count / 2

            if sortedGroup.count % 2 == 0 {
                let medianSpeed = (sortedGroup[middleIndex].speed + sortedGroup[middleIndex - 1].speed) / 2
                let medianDate = sortedGroup[middleIndex].date
                result.append(TimedSpeedData(speed: medianSpeed, date: medianDate))
            } else {
                let medianSpeed = sortedGroup[middleIndex].speed
                let medianDate = sortedGroup[middleIndex].date
                result.append(TimedSpeedData(speed: medianSpeed, date: medianDate))
            }
        }

        // 첫 번째와 마지막 데이터를 원본 데이터의 처음과 끝으로 설정
//        result[0] = TimedSpeedData(speed: data.first!.speed, date: result.first!.date)
//        result[99] = TimedSpeedData(speed: data.last!.speed, date: result.last!.date)

        return result
    }


    func calculateMedianAltitude(data: List<TimedLocationData>) -> [(date: Date, altitude: Double)] {
        ///1000개면 10개씩
        let groupSize = data.count / 100
        var result: [(date: Date, altitude: Double)] = []

        for i in 0..<100 {
            let groupStartIndex = i * groupSize // 0, 10, 20, 30 ... 900, 910, 920, 930, 940, 950, 960, 970, 980, 990

            let groupEndIndex = min((i+1) * groupSize, data.count) // 10, 20, 30, 40...910, 920, 930, 940, 950, 1000
            let group = Array(data[groupStartIndex..<groupEndIndex])

            let sortedGroup = group.sorted { $0.altitude < $1.altitude }
            let middleIndex = sortedGroup.count / 2

            if sortedGroup.count % 2 == 0 {
                let medianAltitude = (sortedGroup[middleIndex].altitude + sortedGroup[middleIndex - 1].altitude) / 2
                let medianDate = sortedGroup[middleIndex].date
                result.append((date: medianDate, altitude: medianAltitude))
            } else {
                let medianAltitude = sortedGroup[middleIndex].altitude
                let medianDate = sortedGroup[middleIndex].date
                result.append((date: medianDate, altitude: medianAltitude))
            }
        }

        // 첫 번째와 마지막 데이터를 원본 데이터의 처음과 끝으로 설정
//        result[0] = (date: data.first!.date, altitude: result.first!.altitude)
//        result[99] = (date: data.last!.date, altitude: result.last!.altitude)

        return result
    }

    func calculated(data: List<TimedLocationData>) -> [(date: Date, altitude: Double)] {

        ///100개면 1개씩 100
        ///150개면 1.5개씩 100개
        ///3600개면 36개씩 100개
        ///3601개면 

        return []
    }
}

class TimedLocationData: Object {
    @Persisted var coordinate: CLLocationCoordinate2D
    @Persisted var date: Date
    @Persisted var altitude: Double

    convenience init(coordinate: CLLocationCoordinate2D, date: Date, altitude: Double) {
        self.init()
        self.coordinate = coordinate
        self.date = date
        self.altitude = altitude
    }
}

class TimedSpeedData: Object {
    @Persisted var speed: Double
    @Persisted var date: Date

   convenience init(speed: Double, date: Date) {
       self.init()
        self.speed = speed
        self.date = date
    }
}
