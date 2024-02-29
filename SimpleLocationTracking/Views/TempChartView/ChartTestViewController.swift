////
////  ChartTestViewController.swift
////  SimpleLocationTracking
////
////  Created by TAEHYOUNG KIM on 2/24/24.
////
//
//import UIKit
//import DGCharts
//import CoreLocation
//
//class ChartTestViewController: UIViewController, ChartViewDelegate {
//
//    var vm: ChartTestViewModel!
//    let combinedChartView = CombinedChartView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        vm = ChartTestViewModel()
//        configureCombinedChart()
//    }
//
//    func configureCombinedChart() {
//
//        combinedChartView.data = vm.setCombinedChartData()
////        combinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateArray.map{ $0.formattedString(.hhMM) })
//        combinedChartView.doubleTapToZoomEnabled = false
//        combinedChartView.pinchZoomEnabled = false
//
//        view.addSubview(combinedChartView)
//        combinedChartView.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.horizontalEdges.equalTo(view).inset(20)
//            $0.height.equalTo(300)        }
//    }
//
//    func setCharts(_ chart: LineChartView) {
//        // disable grid
////        chart.xAxis.drawGridLinesEnabled = false
////        chart.leftAxis.drawGridLinesEnabled = false
////        chart.rightAxis.drawGridLinesEnabled = false
////        chart.drawGridBackgroundEnabled = false
////        // disable axis annotations
////        chart.xAxis.drawLabelsEnabled = false
////        chart.leftAxis.drawLabelsEnabled = false
////        chart.rightAxis.drawLabelsEnabled = false
////        // disable legend
////        chart.legend.enabled = true
////        // disable zoom
////        chart.pinchZoomEnabled = false
////        chart.doubleTapToZoomEnabled = false
////        // remove artifacts around chart area
////        chart.xAxis.enabled = false
////        chart.leftAxis.enabled = false
////        chart.rightAxis.enabled = false
////        chart.drawBordersEnabled = false
////        chart.minOffset = 0
////        // setting up delegate needed for touches handling
////        chart.delegate = self
//    }
//
//}
////
////struct ChartDatasetFactory {
////    func makeChartDataset(colorAsset: DataColor,entries: [ChartDataEntry]) -> LineChartDataSet {
////        var dataSet = LineChartDataSet(entries: entries, label: "")
////
////        // chart main settings
////        dataSet.setColor(colorAsset.color)
////        dataSet.lineWidth = 3
////        dataSet.mode = .cubicBezier // curve smoothing
////        dataSet.drawValuesEnabled = true // disble values
////        dataSet.drawCirclesEnabled = false // disable circles
////        dataSet.drawFilledEnabled = true // gradient setting
////
////        // settings for picking values on graph
////        dataSet.drawHorizontalHighlightIndicatorEnabled = false // leave only vertical line
////        dataSet.highlightLineWidth = 2 // vertical line width
////        dataSet.highlightColor = colorAsset.color // vertical line color
////
////        addGradient(to: &dataSet, colorAsset: colorAsset)
////
////        return dataSet
////    }
////}
////
////private extension ChartDatasetFactory {
////    func addGradient(to dataSet: inout LineChartDataSet, colorAsset: DataColor) {
////        let mainColor = colorAsset.color.withAlphaComponent(0.5)
////        let secondaryColor = colorAsset.color.withAlphaComponent(0)
////        let colors = [
////            mainColor.cgColor,
////            secondaryColor.cgColor,
////            secondaryColor.cgColor
////        ] as CFArray
////        let locations: [CGFloat] = [0, 0.79, 1]
////        if let gradient = CGGradient(
////            colorsSpace: CGColorSpaceCreateDeviceRGB(),
////            colors: colors,
////            locations: locations
////        ) {
////            dataSet.fill = LinearGradientFill(gradient: gradient, angle: 270)
////        }
////    }
////}
////enum DataColor {
////    case first
////    case second
////    case third
////
////    var color: UIColor {
////        switch self {
////        case .first: return UIColor(red: 56/255, green: 58/255, blue: 209/255, alpha: 1)
////        case .second: return UIColor(red: 235/255, green: 113/255, blue: 52/255, alpha: 1)
////        case .third: return UIColor(red: 52/255, green: 235/255, blue: 143/255, alpha: 1)
////        }
////    }
////}
