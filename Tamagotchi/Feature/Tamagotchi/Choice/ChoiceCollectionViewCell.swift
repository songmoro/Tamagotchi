//
//  ChoiceCollectionViewCell.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit
import SnapKit

final class ChoiceCollectionViewCell: UICollectionViewCell, IsIdentifiable {
    let imageView = UIImageView()
    let label = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        label.isUserInteractionEnabled = false
        
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = .clear
        configuration.background.strokeColor = .tint
        configuration.background.cornerRadius = 4
        configuration.attributedTitle = .init("", attributes: .init([.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.tint]))
        configuration.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        label.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
