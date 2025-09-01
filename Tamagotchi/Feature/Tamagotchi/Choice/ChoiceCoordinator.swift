//
//  ChoiceCoordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/27/25.
//

import UIKit

protocol ChoiceCoordinatorDelegate {
    func alert(tamagotchi: Tamagotchi)
}

protocol ChoiceViewControllerDelegate: ViewControllerDelegate {
    func alert(tamagotchi: Tamagotchi)
}

final class ChoiceCoordinator: Coordinator {
    deinit {
        print(self, #function)
    }
    
    var delegate: ChoiceCoordinatorDelegate?
    
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(mode: ChoiceViewModel.Mode) {
        let vm = ChoiceViewModel(mode: mode)
        let vc = ChoiceViewController(viewModel: vm)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension ChoiceCoordinator: ChoiceViewControllerDelegate {
    func dismiss() {
        
    }
    
    func alert(tamagotchi: Tamagotchi) {
        delegate?.alert(tamagotchi: tamagotchi)
    }
}
