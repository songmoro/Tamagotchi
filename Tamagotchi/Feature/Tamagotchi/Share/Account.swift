//
//  Account.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/23/25.
//

struct Account: Codable {
    var nickname: String
    var tamagotchi: Tamagotchi
    var level: Int {
        min(10, max(1, ((food / 5) + (water / 2)) / 10))
    }
    var food: Int
    var water: Int
    
    var imageName: String {
        tamagotchi.imageName(level: level)
    }
    
    init(nickname: String = "대장", tamagotchi: Tamagotchi, food: Int = 0, water: Int = 0) {
        self.nickname = nickname
        self.tamagotchi = tamagotchi
        self.food = food
        self.water = water
    }
}
