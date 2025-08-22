//
//  Tamagochi.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit

struct Tamagochi {
    let image: ImageResource
    let name: String
}

extension Tamagochi: CaseIterable {
    static var allCases: [Tamagochi] {
        [
            .init(image: ._1_6, name: "따끔따끔 다마고치"),
            .init(image: ._2_6, name: "방실방실 다마고치"),
            .init(image: ._3_6, name: "반짝반짝 다마고치")
        ]
        +
        Array(repeating: .init(image: .no, name: "준비중이에요"), count: 20)
    }
}
