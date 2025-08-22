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
    let tamagochiView = TamagochiView()
    let descriptionLabel = UILabel()
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
        let underlineView = UIView()
        
        [tamagochiView, underlineView, descriptionLabel, cancelButton, acceptButton].forEach(contentView.addSubview)
        
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview(\.safeAreaLayoutGuide)
            $0.height.equalToSuperview(\.safeAreaLayoutGuide).multipliedBy(0.6)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        tamagochiView.snp.makeConstraints {
            $0.size.equalToSuperview(\.snp.width).multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
        }
        
        underlineView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(tamagochiView)
            $0.height.equalTo(1)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(underlineView)
            $0.bottom.equalTo(cancelButton.snp.top)
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
        
        tamagochiView.imageView.image = UIImage(resource: ._1_1)
        
        underlineView.backgroundColor = .tint
        
        descriptionLabel.text = """
        저는 방실방실 다마고치입니당 키는 100km
        몸무게는 150톤이에용
        성격은 화끈하고 날라다닙니당~!
        열심히 잘 먹고 잘 클 자신은
        있답니당 방실방실!
        """
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .tint
        descriptionLabel.font = .systemFont(ofSize: 13)
        
        var configuration = UIButton.Configuration.borderless()
        configuration.background.backgroundColor = .background
        configuration.background.strokeColor = .opaqueSeparator
        configuration.background.strokeWidth = 1
        configuration.background.cornerRadius = 0
        
        cancelButton.configuration = configuration
        cancelButton.configuration?.title = "취소"
        acceptButton.configuration = configuration
        acceptButton.configuration?.title = "시작하기"
        cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
    }
    
    @objc func dismissAlert() {
        dismiss(animated: false)
    }
}
