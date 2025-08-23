//
//  MainViewController.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let feedFood: Observable<Int>
        let feedWater: Observable<Int>
    }
    struct Output {
        let nickname: Driver<String>
        let character: Driver<TamagochiCharacter>
    }
    
    let nickname: String
    let character: TamagochiCharacter
    
    init(nickname: String = "대장", tamagochi: Tamagochi) {
        self.nickname = nickname
        self.character = .init(tamagochi: tamagochi)
    }
    
    func transform(_ input: Input) -> Output {
        let nickname = BehaviorRelay(value: self.nickname)
        let character = BehaviorRelay(value: self.character)
        
        input.feedFood
            .withLatestFrom(character) {
                var newCharacter = $1
                newCharacter.food += $0
                
                return newCharacter
            }
            .bind(to: character)
            .disposed(by: disposeBag)
        
        input.feedWater
            .withLatestFrom(character) {
                var newCharacter = $1
                newCharacter.water += $0
                
                return newCharacter
            }
            .bind(to: character)
            .disposed(by: disposeBag)
        
        return .init(nickname: nickname.asDriver(), character: character.asDriver())
    }
}

final class MainViewController: TamagochiViewController<MainViewModel> {
    let tamagochiView = TamagochiView()
    
    let tamagochiLabel = UILabel()
    let foodTextField = UITextField()
    let foodFeedButton = UIButton()
    let waterTextField = UITextField()
    let waterFeedButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func bind() {
//        let output = viewModel.transform(
//            .init(feedFood: <#T##Observable<Int>#>, feedWater: <#T##Observable<Int>#>)
//        )
    }
    
    private func configure() {
        navigationItem.title = "\(viewModel.nickname)님의 다마고치"
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "person.circle"), style: .plain, target: nil, action: nil)
        
        [tamagochiView, tamagochiLabel, foodTextField, foodFeedButton, waterTextField, waterFeedButton].forEach(view.addSubview)
        
        tamagochiView.snp.makeConstraints {
            $0.width.height.equalToSuperview(\.snp.width).multipliedBy(0.6)
            $0.center.equalToSuperview()
        }
        
        tamagochiLabel.snp.makeConstraints {
            $0.top.equalTo(tamagochiView.snp.bottom)
            $0.horizontalEdges.equalTo(tamagochiView)
        }
        
        foodTextField.snp.makeConstraints {
            $0.top.equalTo(tamagochiLabel.snp.bottom).offset(12)
            $0.width.equalTo(tamagochiLabel).multipliedBy(0.6)
            $0.leading.equalTo(tamagochiLabel)
            $0.height.equalTo(40)
        }
        
        foodFeedButton.snp.makeConstraints {
            $0.top.equalTo(tamagochiLabel.snp.bottom).offset(12)
            $0.width.equalTo(tamagochiLabel).multipliedBy(0.4)
            $0.trailing.equalTo(tamagochiLabel)
            $0.height.equalTo(40)
        }
        
        waterTextField.snp.makeConstraints {
            $0.top.equalTo(foodTextField.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(foodTextField)
            $0.height.equalTo(40)
        }
        
        waterFeedButton.snp.makeConstraints {
            $0.top.equalTo(foodFeedButton.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(foodFeedButton)
            $0.height.equalTo(40)
        }
        
        tamagochiView.imageView.image = UIImage(resource: viewModel.character.tamagochi.image)
        tamagochiView.setTitle(viewModel.character.tamagochi.name)
        
        tamagochiLabel.text = "LV\(viewModel.character.level) • 밥알 \(viewModel.character.food)개 • 물방울 \(viewModel.character.water)개"
        tamagochiLabel.textColor = .tint
        tamagochiLabel.textAlignment = .center
        
        foodTextField.placeholder = "밥 주세용"
        waterTextField.placeholder = "물 주세용"
        
        var configuration = UIButton.Configuration.plain()
        configuration.background.cornerRadius = 4
        configuration.background.strokeColor = .tint
        configuration.background.strokeWidth = 1
        
        foodFeedButton.configuration = configuration
        waterFeedButton.configuration = configuration
        
        foodFeedButton.configuration?.title = "밥 주기"
        foodFeedButton.configuration?.image = UIImage(systemName: "leaf.circle")
        waterFeedButton.configuration?.title = "물 주기"
        waterFeedButton.configuration?.image = UIImage(systemName: "drop.circle")
    }
}
