//
//  SceneDelegate.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 10/28/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene) // SceneDelegate의 프로퍼티에 설정해줌
        let tabBarController = MainTabBarController()

        let navigationVC = UINavigationController(rootViewController: tabBarController)
        
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }
}

