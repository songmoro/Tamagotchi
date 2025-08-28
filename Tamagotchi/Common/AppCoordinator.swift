//
//  AppCoordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/27/25.
//

import UIKit

// TODO: 데이터 초기화 시 선택 화면

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
}

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
    
    private func appendChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    private func removeChild(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    private func pop() {
        navigationController.popViewController(animated: true)
    }
    
    private func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    private func new() {
        navigationController.viewControllers = []
        childCoordinators = []
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
    
    private func showChoiceVC(tamagotchi: Tamagotchi? = nil) {
        let coordinator = ChoiceCoordinator(navigationController: navigationController)
        appendChild(coordinator)
        coordinator.delegate = self
        coordinator.start(tamagotchi: tamagotchi)
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
    
    private func showResetAlert() {
        
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func choice(_ coordinator: OnboardingCoordinator) {
        new()
        showChoiceVC()
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
    func nickname() {
        showNicknameVC()
    }
    
    func change(tamagotchi: Tamagotchi) {
        showChoiceVC(tamagotchi: tamagotchi)
    }
    
    func reset() {
        new()
        showChoiceVC()
    }
}

extension AppCoordinator: NicknameCoordinatorDelegate {
    func finish(_ coordinator: NicknameCoordinator) {
        removeChild(coordinator)
        popToRoot()
    }
}
