//
//  AppCoordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/27/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showOnboarding()
    }
    
    func setTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController, LotteryViewController(viewModel: .init()), BoxOfiiceViewController(viewModel: .init())]
        
        if let items = tabBarController.tabBar.items {
            items[0].title = "다마고치"
            items[1].title = "로또"
            items[2].title = "검색"
        }
        
        return tabBarController
    }
    
    private func showOnboarding() {
        let coordinator = OnboardingCoordinator(navigationController: navigationController)
        appendChild(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
    
    private func showMainVC() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        appendChild(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
    
    private func showChoiceVC(mode: ChoiceViewModel.Mode) {
        let coordinator = ChoiceCoordinator(navigationController: navigationController)
        appendChild(coordinator)
        coordinator.delegate = self
        coordinator.start(mode: mode)
    }
    
    private func showChoiceAlertVC(tamagotchi: Tamagotchi) {
        let coordinator = AlertCoordinator(navigationController: navigationController)
        appendChild(coordinator)
        coordinator.delegate = self
        coordinator.start(tamagotchi: tamagotchi)
    }
    
    private func showSettingsVC() {
        let coordinator = SettingsCoordinator(navigationController: navigationController)
        appendChild(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
    
    private func showNicknameVC() {
        let coordinator = NicknameCoordinator(navigationController: navigationController)
        appendChild(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func choice(_ coordinator: OnboardingCoordinator) {
        new()
        showChoiceVC(mode: .choice)
    }
    
    func main(_ coordinator: OnboardingCoordinator) {
        pop()
        removeChild(coordinator)
        showMainVC()
    }
}

extension AppCoordinator: ChoiceCoordinatorDelegate {
    func alert(tamagotchi: Tamagotchi) {
        showChoiceAlertVC(tamagotchi: tamagotchi)
    }
}

extension AppCoordinator: AlertCoordinatorDelegate {
    func finish(_ coordinator: AlertCoordinator) {
        removeChild(coordinator)
        navigationController.tabBarController?.dismiss(animated: false)
    }
    
    func choice(_ coordinator: AlertCoordinator) {
        finish(coordinator)
        pop()
        showMainVC()
    }
    
    func change(_ coordinator: AlertCoordinator) {
        finish(coordinator)
        popToRoot()
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func settings() {
        showSettingsVC()
    }
}

extension AppCoordinator: SettingsCoordinatorDelegate {
    func dismiss() {
        
    }
    
    func nickname() {
        showNicknameVC()
    }
    
    func change() {
        showChoiceVC(mode: .change)
    }
    
    func reset() {
        new()
        showOnboarding()
    }
}

extension AppCoordinator: NicknameCoordinatorDelegate {
    func dismiss(_ coordinator: NicknameCoordinator) {
        removeChild(coordinator)
    }
    
    func finish(_ coordinator: NicknameCoordinator) {
        removeChild(coordinator)
        popToRoot()
    }
}
