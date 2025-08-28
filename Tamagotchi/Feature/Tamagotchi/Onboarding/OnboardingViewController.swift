//
//  OnboardingViewController.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/28/25.
//

import UIKit

final class OnboardingViewController: UIViewController {
    var delegate: OnboardingViewControllerDelegate?
    
    deinit {
        print(self, #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .label
        
        if Container.shared.account == nil {
            delegate?.choice()
        }
        else {
            delegate?.main()
        }
    }
}
