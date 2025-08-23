//
//  MainViewController.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/23/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewModel: ViewModel {
    
}

final class MainViewController: TamagochiViewController<MainViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func bind() {
        
    }
    
    private func configure() {
        navigationItem.title = "대장님의 다마고치"
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "person.circle"), style: .plain, target: nil, action: nil)
    }
}
