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
            self.navigationController?.isNavigationBarHidden = true
        case is HistoryViewController:
            navigationController?.navigationBar.prefersLargeTitles = false
            title = "Tracking History"
            self.navigationController?.isNavigationBarHidden = false
        default:
            break
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateNavigationItem(vc: viewController)
    }
}
