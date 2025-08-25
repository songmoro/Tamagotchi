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
        
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController()
        tabBarController.viewControllers = [navigationController, LotteryViewController(viewModel: .init()), UIViewController()]
        
        if let items = tabBarController.tabBar.items {
            items[0].title = "다마고치"
            items[1].title = "로또"
            items[2].title = "검색"
        }
        
        if let data = UserDefaults.standard.data(forKey: "tamagotchi"), let character = try? PropertyListDecoder().decode(TamagochiCharacter.self, from: data), let nickname = UserDefaults.standard.string(forKey: "nickname") {
            let mainVC = MainViewController(viewModel: MainViewModel(nickname: nickname, character: character))
            navigationController.viewControllers = [mainVC]
        }
        else {
            let choiveVC = ChoiceViewController(viewModel: ChoiceViewModel())
            navigationController.viewControllers = [choiveVC]
        }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
