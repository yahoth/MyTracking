//
//  MainTabBarController.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 12/28/23.
//

import UIKit

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
        case is HistoryViewController:
            navigationController?.navigationBar.prefersLargeTitles = false
            title = "Tracking History"
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
