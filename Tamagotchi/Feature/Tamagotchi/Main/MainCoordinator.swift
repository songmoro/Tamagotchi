//
//  MainCoordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/27/25.
//

import UIKit

protocol MainCoordinatorDelegate {
    func settings()
}

protocol MainViewControllerDelegate {
    func settings()
}

final class MainCoordinator: Coordinator, MainViewControllerDelegate {
    var delegate: MainCoordinatorDelegate?
    
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = MainViewModel()
        let vc = MainViewController(viewModel: vm)
        
        vc.delegate = self
        navigationController.viewControllers = [vc]
    }
    
    func settings() {
        delegate?.settings()
    }
}
