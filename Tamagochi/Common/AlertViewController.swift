//
//  AlertViewController.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit
import SnapKit

final class AlertViewController: UIViewController {
    let contentView = UIView()
    let cancelButton = UIButton()
    let acceptButton = UIButton()
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            UIModalPresentationStyle.overCurrentContext
        }
        set {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.addSubview(contentView)
        [cancelButton, acceptButton].forEach(contentView.addSubview)
        
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview(\.safeAreaLayoutGuide)
            $0.height.equalToSuperview(\.safeAreaLayoutGuide).multipliedBy(0.6)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(60)
        }
        
        acceptButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(60)
        }
        
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.backgroundColor = .background
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        acceptButton.setTitle("확인", for: .normal)
        acceptButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func dismissAlert() {
        dismiss(animated: false)
    }
}
