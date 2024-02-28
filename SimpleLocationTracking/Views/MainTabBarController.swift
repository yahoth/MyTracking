//
//  MainTabBarController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/28/23.
//

import UIKit

import RealmSwift

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        let mainVC = TrackingSetupViewController()
        mainVC.tabBarItem = UITabBarItem(title: "Tracking", image: UIImage(systemName: "speedometer"), tag: 0)

        let historyVC = HistoryViewController()
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "filemenu.and.selection"), tag: 1)

//        let chartVC = ChartTestViewController()
//        chartVC.tabBarItem = UITabBarItem(title: "Chart ", image: UIImage(systemName: "chart.bar"), tag: 2)

        self.viewControllers = [mainVC, historyVC/*, chartVC*/]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationItem(vc: self.selectedViewController!)
    }

    func updateNavigationItem(vc: UIViewController) {
        switch vc {
        case is TrackingSetupViewController:
//            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.rightBarButtonItems = []
            navigationController?.navigationBar.isHidden = true
        case is HistoryViewController:
            navigationController?.navigationBar.prefersLargeTitles = false
            title = "Tracking History"

            let addItem = UIBarButtonItem(image: UIImage(systemName: "plus.app.fill"), style: .done, target: self, action: #selector(addItem))
            navigationItem.rightBarButtonItems = [addItem]
            navigationController?.navigationBar.isHidden = false

//        case is ChartTestViewController:
//            navigationController?.navigationBar.prefersLargeTitles = false
//            title = "Charts"
//
//            navigationItem.rightBarButtonItems = []
        default:
            break
        }
    }

    @objc func addItem() {
//        var components = DateComponents()
//        let calendar = Calendar.current
//        let years = 2020...2025
//        let months = 1...12
//        let day = 1...31
//        components.year = years.randomElement()
//        components.month = months.randomElement()
//        components.day = day.randomElement()
//        let date = calendar.date(from: components)!
//
//        let item = TrackingData(speedInfos: [SpeedInfo()].toRealmList(), pathInfo: PathInfo(), startDate: date, endDate: Date(), startLocation: "\(components.year!)-\(components.month!)-\(components.day!)", endLocation: "hello", activityType: .airplane)
//
//        RealmManager.shared.create(object: item)
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateNavigationItem(vc: viewController)
    }
}
