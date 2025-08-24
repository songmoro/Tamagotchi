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
    private let mainViewModel: MainViewModel?
    
    override init(viewModel: ChoiceViewModel) {
        self.mainViewModel = nil
        super.init(viewModel: viewModel)
        navigationItem.title = "다마고치 선택하기"
    }
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        super.init(viewModel: .init())
        navigationItem.title = "다마고치 변경하기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    @available(*, deprecated)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        Observable.just(viewModel.data)
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: ChoiceCollectionViewCell.identifier, cellType: ChoiceCollectionViewCell.self)) {
                $2.isUserInteractionEnabled = $1 != .preparing
                $2.imageView.image = UIImage(named: $1.imageName(level: 6))
                $2.label.configuration?.attributedTitle? = .init($1.name, attributes: .init([.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.tint]))
            }
            .disposed(by: disposeBag)
        
        if let mainViewModel {
            collectionView.rx.modelSelected(Tamagochi.self)
                .asDriver()
                .drive(with: self) { owner, tamagotchi in
                    let alert = ChangeAlertViewController(viewModel: .init(tamagotchi: tamagotchi), mainViewModel: mainViewModel)
                    owner.present(alert, animated: false)
                }
                .disposed(by: disposeBag)
        }
        else {
            collectionView.rx.modelSelected(Tamagochi.self)
                .asDriver()
                .drive(with: self) { owner, tamagotchi in
                    let alert = AlertViewController(viewModel: .init(tamagotchi: tamagotchi))
                    owner.present(alert, animated: false)
                }
                .disposed(by: disposeBag)
        }
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
