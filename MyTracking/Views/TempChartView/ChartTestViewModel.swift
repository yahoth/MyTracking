////
////  ChartTestViewModel.swift
////  SimpleLocationTracking
////
////  Created by TAEHYOUNG KIM on 2/26/24.
////
//
//import Foundation
//
//import CoreLocation
//import DGCharts
//
//class ChartTestViewModel {
////    var speedsAndAltitudes: [SpeedAndAltitudePerSeconds]
//    var path: PathInfo
//
//    init() {
//        self.path = ChartTestViewModel.tempData()
//    }
//
//    static func tempData() -> PathInfo {
//
////        var speedsAndAltitudes = [SpeedAndAltitudePerSeconds]()
//        var dateArray: [Date] = []
//        var a = [LocationDataPerTenMeters]()
//        var b = [SpeedAndAltitudePerSeconds]()
//
//        let hour = 120
//
//        for i in 1...hour {
//            let date = Date() + TimeInterval(i)
//            dateArray.append(date)
//            a.append(LocationDataPerTenMeters(coordinate: CLLocationCoordinate2D(), date: date))
//            b.append(SpeedAndAltitudePerSeconds(speed: Double((5...10).randomElement()!), altitude: i < hour / 2 ? Double(i) : Double(hour - i), date: date))
//        }
//
//       let path = PathInfo(locationDatas: a, speedsAndAltitudes: b)
//
//        return path
//    }
//
//    func setCombinedChartData() -> CombinedChartData {
//        let data: CombinedChartData = CombinedChartData()
//
//        data.lineData = setChartData().speedLineData
//        data.barData = setChartData().altitudeBarData
//
//        return data
//
//        func setChartData() -> (speedLineData: LineChartData, altitudeBarData: BarChartData) {
//            var speedLineChartEntries = [ChartDataEntry]()
//            var altitudeBarChartEntries = [BarChartDataEntry]()
//
//            for speed in path.filtered() {
//
//                let speedEntry = ChartDataEntry(x: speed.date.timeIntervalSinceNow, y: speed.speed)
//                speedLineChartEntries.append(speedEntry)
//
//                let altitudeEntry = BarChartDataEntry(x: speed.date.timeIntervalSinceNow, y: speed.altitude)
//                altitudeBarChartEntries.append(altitudeEntry)
//            }
//
//            let lineDataSet = LineChartDataSet(entries: speedLineChartEntries, label: "Speed")
//            lineDataSet.drawCirclesEnabled = false
//            lineDataSet.colors = [.red]
//            lineDataSet.mode = .cubicBezier
//            lineDataSet.lineWidth = 1
//
//            let barDataSet = BarChartDataSet(entries: altitudeBarChartEntries, label: "Altitude")
//            barDataSet.barBorderWidth = 1
//            barDataSet.barBorderColor = .brown
//
//            return (LineChartData(dataSet: lineDataSet), BarChartData(dataSet: barDataSet))
//        }
//    }
//
//}
