//
//  ChoiceViewController.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit

final class ChoiceViewModel: ViewModel {
    
}

final class ChoiceViewController: TamagochiViewController<ChoiceViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "다마고치 선택하기"
    }
}
