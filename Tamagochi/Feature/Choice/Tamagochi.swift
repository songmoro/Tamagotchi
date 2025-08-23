//
//  Tamagochi.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit

struct Tamagochi {
    let imageName: String
    let name: String
    var profile: String {
        """
        저는 \(name)입니당 키는 100km
        몸무게는 150톤이에용
        성격은 화끈하고 날라다닙니당~!
        열심히 잘 먹고 잘 클 자신은
        있답니당 방실방실!
        """
    }
    
    var type: Int? {
        Int(imageName.first?.description ?? "")
    }
    var level: Int? {
        Int(imageName.last?.description ?? "")
    }
}

extension Tamagochi: CaseIterable {
    static var allCases: [Tamagochi] {
        [.init(imageName: "1-6", name: "따끔따끔 다마고치"), .init(imageName: "2-6", name: "방실방실 다마고치"), .init(imageName: "3-6", name: "반짝반짝 다마고치")] + Array(repeating: .init(imageName: "noImage", name: "준비중이에요"), count: 21)
    }
}
