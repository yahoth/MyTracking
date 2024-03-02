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

//    func updateNavigationItem(vc: UIViewController) {
//        switch vc {
//        case is TrackingSetupViewController:
//            self.navigationController?.isNavigationBarHidden = true
//        case is HistoryViewController:
//            navigationController?.navigationBar.prefersLargeTitles = false
//            self.navigationController?.isNavigationBarHidden = true
//
//        default:
//            break
//        }
//    }

    func setTabBar() {
//        delegate = self

        let mainVC = TrackingSetupViewController()
        mainVC.tabBarItem = UITabBarItem(title: "Tracking", image: UIImage(systemName: "mappin.and.ellipse"), tag: 0)

        let historyVC = HistoryViewController()
        historyVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "filemenu.and.selection"), tag: 1)

        let settingVC = SettingViewController()

        settingVC.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gearshape"), tag: 2)

        self.viewControllers = [mainVC, historyVC, settingVC]
    }

    func setTabBarColor() {
        let tabBarApppearance = UITabBar.appearance()
        tabBarApppearance.backgroundColor = .systemBackground
    }
}

//extension MainTabBarController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        updateNavigationItem(vc: viewController)
//    }
//}
