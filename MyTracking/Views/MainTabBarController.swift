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
        setTabBar()
        setTabBarColor()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        updateNavigationItem(vc: self.selectedViewController!)
        self.navigationController?.isNavigationBarHidden = true

    }


    func setTabBar() {
//        delegate = self

        let mainVC = TrackingSetupViewController()
        mainVC.tabBarItem = UITabBarItem(title: "Tracking".localized(), image: UIImage(systemName: "mappin.and.ellipse"), tag: 0)

        let historyVC = HistoryViewController()
        historyVC.tabBarItem = UITabBarItem(title: "History".localized(), image: UIImage(systemName: "filemenu.and.selection"), tag: 1)

        self.viewControllers = [mainVC, historyVC]
    }

    func setTabBarColor() {
        let tabBarApppearance = UITabBar.appearance()
        tabBarApppearance.backgroundColor = .systemBackground
    }
}
