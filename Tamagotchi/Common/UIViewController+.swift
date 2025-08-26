//
//  UIViewController+.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/26/25.
//

import UIKit
import SnapKit

enum TransitionStyle {
    case present
    case presentNavigation
    case push
}

extension UIViewController {
    final func transition<T: UIViewController>(_ viewController: T, _ style: TransitionStyle) {
        switch style {
        case .present:
            present(viewController, animated: true)
        case .presentNavigation:
            present(UINavigationController(rootViewController: viewController), animated: true)
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    final func showToast(_ message: String) {
        let uiView: UIView = {
            let view = UIView()
            view.backgroundColor = .label
            view.layer.cornerRadius = 8
            
            return view
        }()
        let label: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .systemBackground
            
            return label
        }()
        
        view.addSubview(uiView)
        uiView.addSubview(label)
        
        uiView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(label).multipliedBy(1.5)
            $0.width.equalTo(label).multipliedBy(1.2)
        }
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            uiView.removeFromSuperview()
        }
    }
    
    final func showAlert(_ title: String? = nil, _ message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(alert, animated: true)
    }
}
