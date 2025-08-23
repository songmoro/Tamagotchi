//
//  TamagochiCharacter.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/23/25.
//

struct TamagochiCharacter {
    var tamagochi: Tamagochi
    var level: Int {
        min(10, max(1, ((food / 5) + (water / 2)) / 10))
    }
    var food: Int
    var water: Int
    
    init(tamagochi: Tamagochi, food: Int = 0, water: Int = 0) {
        self.tamagochi = tamagochi
        self.food = food
        self.water = water
    }
}
