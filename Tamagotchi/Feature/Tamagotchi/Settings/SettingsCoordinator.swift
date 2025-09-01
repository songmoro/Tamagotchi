//
//  SettingsCoordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/27/25.
//

import UIKit

protocol SettingsCoordinatorDelegate: CoordinatorDelegate {
    func nickname()
    func change()
    func reset()
}

// TODO: 코디네이터 딜리게이트 프로토콜 생성
// -> NSObject 채택
// -> Reactive 확장
// -> vc.delegate.transition(_ type: TransitionType) where TransitionType: enum
// = vc에서 화면 전환 분기 제거
// = drive(with: self) -> drive(delegate.transition(_:))

protocol SettingsViewControllerDelegate: ViewControllerDelegate {
    func section(_ section: SettingsViewController.Section)
}

final class SettingsCoordinator: Coordinator, SettingsViewControllerDelegate {
    deinit {
        print(self, #function)
    }
    
    var delegate: SettingsCoordinatorDelegate?
    
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let account = Container.shared.account.value ?? .init(tamagotchi: .preparing)
        
        let vm = SettingsViewModel(initialState: .init(account: account, settings: .nickname(""), section: nil))
        let vc = SettingsViewController(viewModel: vm)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func nickname() {
        delegate?.nickname()
    }
    
    private func change() {
        delegate?.change()
    }
    
    private func reset() {
        let alert = UIAlertController(title: "데이터 초기화", message: "정말 다시 처음부터 시작하실 건가용?", preferredStyle: .alert)
        alert.addAction(.init(title: "아냐!", style: .cancel))
        alert.addAction(.init(title: "웅", style: .destructive, handler: { [weak self] _ in
            Container.shared.account.accept(nil)
            self?.delegate?.reset()
        }))
        
        navigationController.present(alert, animated: true)
    }
    
    func dismiss() {
        delegate?.dismiss()
    }
    
    func section(_ section: SettingsViewController.Section) {
        switch section {
        case .nickname:
            nickname()
        case .tamagotchi:
            change()
        case .reset:
            reset()
        }
    }
}
