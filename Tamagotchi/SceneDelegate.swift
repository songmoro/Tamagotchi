//
//  SceneDelegate.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .light
        
        let coordinator = AppCoordinator(navigationController: UINavigationController())
        let tabBarController = coordinator.setTabBarController()
        coordinator.start()
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
