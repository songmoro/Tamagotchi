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
                $2.label.configuration?.attributedTitle? = .init($1.name, attributes: .init([.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.tint]))
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
