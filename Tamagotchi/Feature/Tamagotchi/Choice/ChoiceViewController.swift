//
//  ChoiceViewController.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// TODO: ChoiceViewModelProtocol
final class ChoiceViewController: ViewController<ChoiceViewModel> {
    var delegate: ChoiceViewControllerDelegate?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func configure() {
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
        let output = viewModel.transform(
            .init(
                model: collectionView.rx.modelSelected(Tamagotchi.self).asObservable()
            )
        )
        
        output.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.items
            .drive(collectionView.rx.items(cellIdentifier: ChoiceCollectionViewCell.identifier, cellType: ChoiceCollectionViewCell.self)) {
                $2.isUserInteractionEnabled = $1 != .preparing
                $2.imageView.image = UIImage(named: $1.imageName(level: 6))
                $2.label.configuration?.attributedTitle? = .init($1.name, attributes: .init([.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.tint]))
            }
            .disposed(by: disposeBag)
        
        output.choice
            .drive(with: self) { owner, tamagotchi in
                owner.delegate?.alert(tamagotchi: tamagotchi)
            }
            .disposed(by: disposeBag)
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 150)
        layout.sectionInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        
        return layout
    }
}
