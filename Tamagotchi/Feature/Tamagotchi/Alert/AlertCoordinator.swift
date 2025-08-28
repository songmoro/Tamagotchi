//
//  AlertCoordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/27/25.
//

import UIKit

protocol AlertCoordinatorDelegate {
    func finish(_ coordinator: AlertCoordinator)
    func choice(_ coordinator: AlertCoordinator)
    func change(_ coordinator: AlertCoordinator)
}

protocol AlertViewControllerDelegate {
    func finish()
    func choice()
    func change()
}

final class AlertCoordinator: Coordinator {
    deinit {
        print(self, #function)
    }
    
    var delegate: AlertCoordinatorDelegate?
    
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(tamagotchi: Tamagotchi) {
        let vm = AlertViewModel(tamagotchi: tamagotchi)
        let vc = AlertViewController(viewModel: vm)
        vc.delegate = self
        navigationController.tabBarController?.present(vc, animated: false)
    }
}

extension AlertCoordinator: AlertViewControllerDelegate {
    func finish() {
        delegate?.finish(self)
    }
    
    func choice() {
        delegate?.choice(self)
    }
    
    func change() {
        delegate?.change(self)
    }
}
