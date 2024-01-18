//
//  AppDelegate.swift
//  SimpleLocationTracking
//
//  Created by TAEHYOUNG KIM on 10/28/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard

        if defaults.object(forKey: "unitOfSpeed") == nil {
            defaults.set("kmh", forKey: "unitOfSpeed")
        }

        if defaults.object(forKey: "activityType") == nil {
            defaults.set("cycling", forKey: "activityType")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

