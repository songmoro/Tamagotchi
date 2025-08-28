//
//  Settings.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/24/25.
//

import UIKit

struct Settings {
    let image: UIImage?
    let text: String
    let secondaryText: String?
    
    init(image: UIImage?, text: String, secondaryText: String? = nil) {
        self.image = image
        self.text = text
        self.secondaryText = secondaryText
    }
    
    static func makeSettings(_ nickname: String) -> [Settings] {
        [
            .init(image: UIImage(systemName: "pencil"), text: "내 이름 설정하기", secondaryText: nickname),
            .init(image: UIImage(systemName: "moon.fill"), text: "다마고치 변경하기"),
            .init(image: UIImage(systemName: "goforward"), text: "데이터 초기화")
        ]
    }
}
