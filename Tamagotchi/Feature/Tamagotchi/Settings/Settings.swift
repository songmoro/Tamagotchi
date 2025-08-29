//
//  Settings.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/24/25.
//

import UIKit

enum Settings: Hashable, CaseIterable {
    static var allCases: [Settings] = [.nickname(""), .tamagotchi, .reset]
    
    case nickname(String)
    case tamagotchi
    case reset
    
    var image: UIImage? {
        switch self {
        case .nickname:
            UIImage(systemName: "pencil")
        case .tamagotchi:
            UIImage(systemName: "moon.fill")
        case .reset:
            UIImage(systemName: "goforward")
        }
    }
    
    var text: String {
        switch self {
        case .nickname:
            "내 이름 설정하기"
        case .tamagotchi:
            "다마고치 변경하기"
        case .reset:
            "데이터 초기화"
        }
    }
    
    var secondaryText: String? {
        switch self {
        case .nickname(let string):
            string
        default: nil
        }
    }
    
    static func ==(lhs: Settings, rhs: Settings) -> Bool {
        return lhs.text == rhs.text
    }
}
