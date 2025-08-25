//
//  Tamagochi.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit

enum Tamagochi: Int, Codable, CaseIterable {
    static var allCases: [Tamagochi] = [
        .cactus, .sun, .starfish,
        .preparing, .preparing, .preparing, .preparing, .preparing,
        .preparing, .preparing, .preparing, .preparing, .preparing,
        .preparing, .preparing, .preparing, .preparing, .preparing,
        .preparing, .preparing, .preparing, .preparing, .preparing
    ]
    
    case cactus = 1
    case sun
    case starfish
    case preparing
    
    var name: String {
        switch self {
        case .cactus:
            "따끔따끔 다마고치"
        case .sun:
            "방실방실 다마고치"
        case .starfish:
            "반짝반짝 다마고치"
        case .preparing:
            "준비중이에요"
        }
    }
    
    var profile: String {
        switch self {
        case .cactus, .sun, .starfish:
            """
            저는 \(name)입니당 키는 100km
            몸무게는 150톤이에용
            성격은 화끈하고 날라다닙니당~!
            열심히 잘 먹고 잘 클 자신은
            있답니당 방실방실!
            """
        case .preparing:
            ""
        }
    }
    
    func imageName(level: Int) -> String {
        switch self {
        case .cactus, .sun, .starfish:
            return self.rawValue.description + "-" + min(level, 9).description
        case .preparing:
            return "noImage"
        }
    }
}
