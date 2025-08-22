//
//  ChoiceViewController.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AlertViewController: UIViewController {
    let contentView = UIView()
    let cancelButton = UIButton()
    let acceptButton = UIButton()
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            UIModalPresentationStyle.overCurrentContext
        }
        set {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.addSubview(contentView)
        [cancelButton, acceptButton].forEach(contentView.addSubview)
        
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview(\.safeAreaLayoutGuide)
            $0.height.equalToSuperview(\.safeAreaLayoutGuide).multipliedBy(0.6)
            $0.width.equalToSuperview().multipliedBy(0.8)
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
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        acceptButton.setTitle("확인", for: .normal)
        acceptButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func dismissAlert() {
        dismiss(animated: false)
    }
}

final class ChoiceViewController: TamagochiViewController<ChoiceViewModel> {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func configure() {
        navigationItem.title = "다마고치 선택하기"
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        collectionView.register(ChoiceCollectionViewCell.self)
        collectionView.backgroundColor = nil
        collectionView.collectionViewLayout = layout()
    }
    
    private func bind() {
        Observable.just(viewModel.data)
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: ChoiceCollectionViewCell.identifier, cellType: ChoiceCollectionViewCell.self)) {
                $2.imageView.image = UIImage(resource: $1.image)
                $2.label.configuration?.attributedTitle? = .init($1.name, attributes: .init([.font: UIFont.systemFont(ofSize: 12)]))
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Tamagochi.self)
            .asDriver()
            .drive {
                let alert = AlertViewController()
                self.present(alert, animated: false)
                _ = $0
            }
            .disposed(by: disposeBag)
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 150)
        layout.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        return layout
    }
}
