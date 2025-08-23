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
        window?.overrideUserInterfaceStyle = .light
        
        let navigationViewController = UINavigationController()
        
        if let data = UserDefaults.standard.data(forKey: "tamagochi"), let character = try? PropertyListDecoder().decode(TamagochiCharacter.self, from: data) {
            let mainVC = MainViewController(viewModel: MainViewModel(character: character))
            navigationViewController.viewControllers = [mainVC]
        }
        else {
            let choiveVC = ChoiceViewController(viewModel: ChoiceViewModel())
            navigationViewController.viewControllers = [choiveVC]
        }
        
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }
}
