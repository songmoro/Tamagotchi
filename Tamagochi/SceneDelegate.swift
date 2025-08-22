//
//  SceneDelegate.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationViewController = UINavigationController()
        navigationViewController.viewControllers = [ChoiceViewController()]
        
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }
}
