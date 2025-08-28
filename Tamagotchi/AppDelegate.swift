//
//  AppDelegate.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIButton.appearance().tintColor = .tint
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tint]
        UIBarButtonItem.appearance().tintColor = .tint
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
