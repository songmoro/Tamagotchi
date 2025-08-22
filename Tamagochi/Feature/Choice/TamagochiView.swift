//
//  TamagochiView.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/23/25.
//

import UIKit
import SnapKit

final class TamagochiView: UIView {
    let imageView = UIImageView()
    let label = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(imageView)
        addSubview(label)
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalToSuperview().multipliedBy(0.8)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        label.isUserInteractionEnabled = false
        
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = .clear
        configuration.background.strokeColor = .tint
        configuration.background.cornerRadius = 4
        configuration.attributedTitle = .init()
        configuration.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        label.configuration = configuration
    }
    
    func setTitle(_ string: String) {
        label.configuration?.attributedTitle = .init(string, attributes: .init([.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.tint]))
    }
}
