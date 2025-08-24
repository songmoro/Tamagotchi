//
//  UnderlineTextField.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/24/25.
//

import UIKit
import SnapKit

final class UnderlineTextField: UITextField {
    private let underlineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(underlineView)
        
        underlineView.backgroundColor = .tint
        
        underlineView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
