//
//  TamagochiCharacter.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/23/25.
//

struct TamagochiCharacter: Codable {
    var tamagotchi: Tamagochi
    var level: Int {
        min(10, max(1, ((food / 5) + (water / 2)) / 10))
    }
    var food: Int
    var water: Int
    
    var imageName: String {
        tamagotchi.imageName(level: level)
    }
    
    init(tamagotchi: Tamagochi, food: Int = 0, water: Int = 0) {
        self.tamagotchi = tamagotchi
        self.food = food
        self.water = water
    }
}
