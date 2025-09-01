//
//  OnboardingCoordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/28/25.
//

import UIKit

protocol OnboardingCoordinatorDelegate {
    func choice(_ coordinator: OnboardingCoordinator)
    func main(_ coordinator: OnboardingCoordinator)
}
protocol OnboardingViewControllerDelegate {
    func onboarding()
}

final class OnboardingCoordinator: Coordinator {
    deinit {
        print(self, #function)
    }
    
    var delegate: OnboardingCoordinatorDelegate?
    
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = OnboardingViewController()
        vc.delegate = self
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    private func choice() {
        delegate?.choice(self)
    }
    
    private func main() {
        delegate?.main(self)
    }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {
    func onboarding() {
        if Container.shared.account.value == nil {
            choice()
        }
        else {
            main()
        }
    }
}
