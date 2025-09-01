//
//  MainViewController.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: ViewController<MainViewModel, MainCoordinator> {
    private let bubbleImageView = UIImageView(image: .bubble)
    private let bubbleLabel = UILabel()
    private let tamagotchiView = TamagochiView()
    private let tamagotchiLabel = UILabel()
    private let foodTextField = UnderlineTextField()
    private let foodFeedButton = UIButton()
    private let waterTextField = UnderlineTextField()
    private let waterFeedButton = UIButton()
    
    private let becomeRoot = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeRoot.accept(())
    }
    
    private func bind() {
        let output = viewModel.transform(
            .init(
                bubble: becomeRoot.asObservable(),
                foodText: foodTextField.rx.text.orEmpty.asObservable(),
                foodButtonTap: foodFeedButton.rx.tap.asObservable(),
                waterText: waterTextField.rx.text.orEmpty.asObservable(),
                waterButtonTap: waterFeedButton.rx.tap.asObservable()
            )
        )
        
        Observable.combineLatest(output.bubble.asObservable(), output.account.asObservable())
            .map { $0 + $1.nickname }
            .bind(to: bubbleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.account
            .map(\.nickname)
            .map { "\($0)님의 다마고치" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.account
            .map {
                "LV\($0.level) • 밥알 \($0.food)개 • 물방울 \($0.water)개"
            }
            .drive(with: self) {
                $0.tamagotchiLabel.text = $1
                $0.becomeRoot.accept(())
            }
            .disposed(by: disposeBag)
        
        output.account
            .map { UIImage(named: $0.imageName) }
            .drive(tamagotchiView.imageView.rx.image)
            .disposed(by: disposeBag)
        
        output.account
            .map(\.tamagotchi.name)
            .drive(with: self) {
                $0.tamagotchiView.setTitle($1)
            }
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .asDriver()
            .drive(with: self) {
                _ = $1
                $0.delegate?.settings()
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "person.circle"), style: .plain, target: nil, action: nil)
        
        [bubbleImageView, bubbleLabel, tamagotchiView, tamagotchiLabel, foodTextField, foodFeedButton, waterTextField, waterFeedButton].forEach(view.addSubview)
        
        tamagotchiView.snp.makeConstraints {
            $0.width.height.equalToSuperview(\.snp.width).multipliedBy(0.6)
            $0.center.equalToSuperview()
        }
        
        bubbleLabel.snp.makeConstraints {
            $0.bottom.equalTo(tamagotchiView.snp.top).offset(-12)
            $0.horizontalEdges.equalTo(tamagotchiView)
            $0.height.equalTo(tamagotchiView.snp.width).multipliedBy(0.6)
        }
        
        bubbleImageView.snp.makeConstraints {
            $0.size.equalTo(bubbleLabel).multipliedBy(1.1)
            $0.center.equalTo(bubbleLabel)
        }
        
        tamagotchiLabel.snp.makeConstraints {
            $0.top.equalTo(tamagotchiView.snp.bottom)
            $0.horizontalEdges.equalTo(tamagotchiView)
        }
        
        foodTextField.snp.makeConstraints {
            $0.top.equalTo(tamagotchiLabel.snp.bottom).offset(12)
            $0.width.equalTo(tamagotchiLabel).multipliedBy(0.55)
            $0.leading.equalTo(tamagotchiLabel)
            $0.height.equalTo(40)
        }
        
        foodFeedButton.snp.makeConstraints {
            $0.top.equalTo(tamagotchiLabel.snp.bottom).offset(12)
            $0.width.equalTo(tamagotchiLabel).multipliedBy(0.4)
            $0.trailing.equalTo(tamagotchiLabel)
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
        
        bubbleLabel.textAlignment = .center
        bubbleLabel.numberOfLines = 0
        bubbleLabel.textColor = .tint
        
        tamagotchiLabel.textColor = .tint
        tamagotchiLabel.textAlignment = .center
        
        foodTextField.placeholder = "밥 주세용"
        foodTextField.textAlignment = .center
        waterTextField.placeholder = "물 주세용"
        waterTextField.textAlignment = .center
        
        var configuration = UIButton.Configuration.plain()
        configuration.background.cornerRadius = 4
        configuration.background.strokeColor = .tint
        configuration.background.strokeWidth = 1
        
        foodFeedButton.configuration = configuration
        waterFeedButton.configuration = configuration
        
        foodFeedButton.configuration?.title = "밥먹기"
        foodFeedButton.configuration?.image = UIImage(systemName: "leaf.circle")
        waterFeedButton.configuration?.title = "물먹기"
        waterFeedButton.configuration?.image = UIImage(systemName: "drop.circle")
    }
}
