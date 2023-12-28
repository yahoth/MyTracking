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

        let mainVC = TrackingSetupViewController()
        mainVC.title = "Main"
        mainVC.tabBarItem = UITabBarItem(title: "Tracking", image: UIImage(systemName: "speedometer"), tag: 0)

        let historyVC = HistoryViewController()
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "filemenu.and.selection"), tag: 1)

        self.viewControllers = [mainVC, historyVC]
    }
}
