//
//  ChartTestViewModel.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 2/26/24.
//

import Foundation

import CoreLocation
import DGCharts

class ChartTestViewModel {
    var pathInfo: PathInfo

    init() {
//        self.pathInfo = pathInfo
        self.pathInfo = ChartTestViewModel.tempData()
    }

    static func tempData() -> PathInfo {
        var timedLocationDatas = [TimedLocationData]()
        var timedSpeedDatas = [TimedSpeedData]()
        var dateArray: [Date] = []

        let hour = 150 // 1시간

        for i in 1...hour {
            let date = Date() + TimeInterval(i)
            dateArray.append(date)

            let locationData = TimedLocationData(coordinate: CLLocationCoordinate2D(), date: date, altitude: i < hour / 2 ? Double(i) : Double(hour - i))

            timedLocationDatas.append(locationData)
            timedSpeedDatas.append(TimedSpeedData(speed: Double((5...10).randomElement()!), date: date))
            print("idx: \(i), altitude: \(locationData.altitude)")
        }
        return PathInfo(locationDatas: timedLocationDatas, speeds: timedSpeedDatas)
    }

    func setChartData() -> CombinedChartData {
        let data: CombinedChartData = CombinedChartData()

        data.barData = setAltitudeBarChartData()
//        data.lineData = setSpeedLineChartData()

        return data

        func setSpeedLineChartData() -> LineChartData {
            var speedLineChartEntries = [ChartDataEntry]()
            for speed in pathInfo.speedStatisticsData {
                let entry = ChartDataEntry(x: speed.date.timeIntervalSinceNow, y: speed.speed)
                speedLineChartEntries.append(entry)
            }
            let lineDataSet = LineChartDataSet(entries: speedLineChartEntries, label: "Speed")
            lineDataSet.drawCirclesEnabled = false
            lineDataSet.colors = [.red]
            lineDataSet.mode = .cubicBezier
            lineDataSet.lineWidth = 1

            return LineChartData(dataSet: lineDataSet)
        }

        func setAltitudeBarChartData() -> BarChartData {
            var altitudeBarChartEntries = [BarChartDataEntry]()

            for locationData in pathInfo.altitudeStatisticsData {
                let entry = BarChartDataEntry(x: locationData.date.timeIntervalSinceNow, y: locationData.altitude)
                altitudeBarChartEntries.append(entry)
            }

            let barDataSet = BarChartDataSet(entries: altitudeBarChartEntries, label: "Altitude")


            barDataSet.barBorderWidth = 1
            barDataSet.barBorderColor = .brown

            return BarChartData(dataSet: barDataSet)
        }
    }

}
