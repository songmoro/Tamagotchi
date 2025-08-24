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

final class MainViewController: TamagochiViewController<MainViewModel> {
    let bubbleImageView = UIImageView(image: .bubble)
    let bubbleLabel = UILabel()
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
        let output = viewModel.transform(
            .init(
                foodText: foodTextField.rx.text.orEmpty.asObservable(),
                foodButtonTap: foodFeedButton.rx.tap.asObservable(),
                waterText: waterTextField.rx.text.orEmpty.asObservable(),
                waterButtonTap: waterFeedButton.rx.tap.asObservable()
            )
        )
        
        output.character
            .map {
                "LV\($0.level) • 밥알 \($0.food)개 • 물방울 \($0.water)개"
            }
            .drive(tamagochiLabel.rx.text)
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .asDriver()
            .drive(with: self) {
                _ = $1
                let settingsVC = SettingsViewController(viewModel: .init())
                $0.navigationController?.pushViewController(settingsVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        navigationItem.backButtonTitle = ""
        navigationItem.title = "\(viewModel.nickname)님의 다마고치"
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "person.circle"), style: .plain, target: nil, action: nil)
        
        [bubbleImageView, bubbleLabel, tamagochiView, tamagochiLabel, foodTextField, foodFeedButton, waterTextField, waterFeedButton].forEach(view.addSubview)
        
        tamagochiView.snp.makeConstraints {
            $0.width.height.equalToSuperview(\.snp.width).multipliedBy(0.6)
            $0.center.equalToSuperview()
        }
        
        bubbleLabel.snp.makeConstraints {
            $0.bottom.equalTo(tamagochiView.snp.top).offset(-12)
            $0.horizontalEdges.equalTo(tamagochiView)
            $0.height.equalTo(tamagochiView.snp.width).multipliedBy(0.6)
        }
        
        bubbleImageView.snp.makeConstraints {
            $0.size.equalTo(bubbleLabel).multipliedBy(1.1)
            $0.center.equalTo(bubbleLabel)
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
        
        tamagochiView.imageView.image = UIImage(named: viewModel.character.tamagochi.imageName)
        tamagochiView.setTitle(viewModel.character.tamagochi.name)
        
        bubbleLabel.text = "좋은 아침!"
        bubbleLabel.textAlignment = .center
        bubbleLabel.numberOfLines = 0
        bubbleLabel.textColor = .tint
        
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
