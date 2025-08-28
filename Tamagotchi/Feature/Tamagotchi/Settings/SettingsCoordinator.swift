//
//  SettingsCoordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/27/25.
//

import UIKit

protocol SettingsCoordinatorDelegate {
    func nickname()
    func change(tamagotchi: Tamagotchi)
    func reset()
}

protocol SettingsViewControllerDelegate {
    func nickname()
    func change(tamagotchi: Tamagotchi)
    func reset(handler: @escaping () -> Void)
}

final class SettingsCoordinator: Coordinator, SettingsViewControllerDelegate {
    var delegate: SettingsCoordinatorDelegate?
    
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = SettingsViewModel()
        let vc = SettingsViewController(viewModel: vm)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func nickname() {
        delegate?.nickname()
    }
    
    func change(tamagotchi: Tamagotchi) {
        delegate?.change(tamagotchi: tamagotchi)
    }
    
    func reset(handler: @escaping () -> Void) {
        let alert = UIAlertController(title: "데이터 초기화", message: "정말 다시 처음부터 시작하실 건가용?", preferredStyle: .alert)
        alert.addAction(.init(title: "아냐!", style: .cancel))
        alert.addAction(.init(title: "웅", style: .destructive, handler: { [weak self] _ in
            handler()
            self?.delegate?.reset()
        }))
        
        navigationController.present(alert, animated: true)
    }
}
