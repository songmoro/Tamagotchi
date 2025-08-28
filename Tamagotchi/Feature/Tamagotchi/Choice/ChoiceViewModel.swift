//
//  ChoiceViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit

final class ChoiceViewModel: ViewModel {
    let tamagotchi: Tamagotchi?
    let data: [Tamagotchi] = Tamagotchi.allCases
    
    init(tamagotchi: Tamagotchi? = nil) {
        self.tamagotchi = tamagotchi
    }
}
