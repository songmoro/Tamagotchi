//
//  ChangeAlertViewController.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChangeAlertViewController: TamagochiViewController<ChangeAlertViewModel> {
    private let mainViewModel: MainViewModel
    private let contentView = UIView()
    private let tamagochiView = TamagochiView()
    private let descriptionLabel = UILabel()
    private let cancelButton = UIButton()
    private let acceptButton = UIButton()
    
    init(viewModel: ChangeAlertViewModel, mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        super.init(viewModel: viewModel)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(
            .init(
                cancelTap: cancelButton.rx.tap.asObservable(),
                acceptTap: acceptButton.rx.tap.asObservable()
            )
        )
        
        output.dismiss
            .drive(with: self) {
                _ = $1
                $0.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        output.change
            .withLatestFrom(mainViewModel.share.character.asDriver(), resultSelector: {
                var newCharacter = $1
                newCharacter.tamagochi = $0.tamagochi
                
                return newCharacter
            })
            .drive(with: self) { owner, character in
                owner.mainViewModel.share.character.accept(character)
                owner.dismiss(animated: false)
                (owner.view.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.addSubview(contentView)
        let underlineView = UIView()
        
        [tamagochiView, underlineView, descriptionLabel, cancelButton, acceptButton].forEach(contentView.addSubview)
        
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview(\.safeAreaLayoutGuide)
            $0.height.equalToSuperview(\.safeAreaLayoutGuide).multipliedBy(0.6)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        tamagochiView.snp.makeConstraints {
            $0.size.equalToSuperview(\.snp.width).multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
        }
        
        underlineView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(tamagochiView)
            $0.height.equalTo(1)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(underlineView)
            $0.bottom.equalTo(cancelButton.snp.top)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(60)
        }
        
        acceptButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(60)
        }
        
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.backgroundColor = .background
        
        tamagochiView.imageView.image = UIImage(named: viewModel.tamagochi.imageName(level: 6))
        tamagochiView.setTitle(viewModel.tamagochi.name)
        underlineView.backgroundColor = .tint
        
        descriptionLabel.text = viewModel.tamagochi.profile
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .tint
        descriptionLabel.font = .systemFont(ofSize: 13)
        
        var configuration = UIButton.Configuration.borderless()
        configuration.background.backgroundColor = .background
        configuration.background.strokeColor = .opaqueSeparator
        configuration.background.strokeWidth = 1
        configuration.background.cornerRadius = 0
        
        cancelButton.configuration = configuration
        cancelButton.configuration?.title = "취소"
        acceptButton.configuration = configuration
        acceptButton.configuration?.title = "변경하기"
    }
}
