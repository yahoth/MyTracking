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

        self.viewControllers = [mainVC, historyVC]
    }

    override func viewWillAppear(_ animated: Bool) {
        updateNavigationItem(vc: self.selectedViewController!)
    }

    func updateNavigationItem(vc: UIViewController) {
        switch vc {
        case is TrackingSetupViewController:
            navigationController?.navigationBar.prefersLargeTitles = true
            title = "Go Tracking"
            navigationItem.rightBarButtonItems = []
        case is HistoryViewController:
            navigationController?.navigationBar.prefersLargeTitles = false
            title = "Tracking History"

            let addItem = UIBarButtonItem(image: UIImage(systemName: "plus.app.fill"), style: .done, target: self, action: #selector(addItem))
            let resetItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(resetItem))
            navigationItem.rightBarButtonItems = [addItem, resetItem]

        default:
            break
        }
    }

    @objc func resetItem() {
        RealmManager.shared.deleteAll()
    }

    @objc func addItem() {
        var components = DateComponents()
        let calendar = Calendar.current

        components.year = 2023
        components.month = 4
        let april2023 = calendar.date(from: components)
//
//        components.month = 1
//        let january2023 = calendar.date(from: components)
//
//        components.year = 2024
//        components.month = 2
//        let february2024 = calendar.date(from: components)
//
//        components.month = 3
//        let march2024 = calendar.date(from: components)

        let item = TrackingData(speedInfos: [SpeedInfo()].toRealmList(), pathInfos: [PathInfo()].toRealmList(), startDate: april2023!, endDate: Date(), startLocation: "2023 - 4", endLocation: "hello")

        RealmManager.shared.create(object: item)
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateNavigationItem(vc: viewController)
    }
}
