//
//  NicknameCoordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/28/25.
//

import UIKit

protocol NicknameCoordinatorDelegate {
    func dismiss(_ coordinator: NicknameCoordinator)
    func finish(_ coordinator: NicknameCoordinator)
}

protocol NicknameViewControllerDelegate: ViewControllerDelegate {
    func finish()
}

final class NicknameCoordinator: Coordinator, NicknameViewControllerDelegate {
    deinit {
        print(self, #function)
    }
    
    var delegate: NicknameCoordinatorDelegate?
    
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = NicknameViewModel(initialState: .init())
        let vc = NicknameViewController(viewModel: vm)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func finish() {
        delegate?.finish(self)
    }
    
    func dismiss() {
        delegate?.dismiss(self)
    }
}
