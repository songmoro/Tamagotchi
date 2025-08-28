//
//  ChangeAlertCoordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/28/25.
//

import UIKit

protocol ChangeAlertCoordinatorDelegate {
    
}

protocol ChangeAlertViewControllerDelegate {
    
}

final class ChangeAlertCoordinator: Coordinator, ChangeAlertViewControllerDelegate {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = ChangeAlertViewModel()
        let vc = ChangeAlertViewController(viewModel: vm)
        vc.delegate = self
        navigationController.tabBarController?.present(vc, animated: false)
    }
}
