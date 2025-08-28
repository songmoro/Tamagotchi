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

protocol ChoiceViewControllerDelegate {
    func alert(tamagotchi: Tamagotchi)
}

final class ChoiceCoordinator: Coordinator {
    var delegate: ChoiceCoordinatorDelegate?
    
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(tamagotchi: Tamagotchi? = nil) {
        let vm = ChoiceViewModel(tamagotchi: tamagotchi)
        let vc = ChoiceViewController(viewModel: vm)
        
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension ChoiceCoordinator: ChoiceViewControllerDelegate {
    func alert(tamagotchi: Tamagotchi) {
        delegate?.alert(tamagotchi: tamagotchi)
    }
    
    func change(tamagotchi: Tamagotchi) {
        delegate?.alert(tamagotchi: tamagotchi)
    }
}
