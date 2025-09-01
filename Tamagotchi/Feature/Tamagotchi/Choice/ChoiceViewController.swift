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

final class ChoiceViewController: ViewController<ChoiceViewModel, ChoiceCoordinator> {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Tamagotchi>!
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(ChoiceCollectionViewCell.self)
        collectionView.backgroundColor = nil
        return collectionView
    }()
    
    enum Section {
        case tamagotchi
    }
    
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
        
        collectionView.collectionViewLayout = layout()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(ChoiceCollectionViewCell.self, for: indexPath)
            cell.isUserInteractionEnabled = itemIdentifier != .preparing
            cell.imageView.image = UIImage(named: itemIdentifier.imageName(level: 6))
            cell.label.configuration?.attributedTitle? = .init(itemIdentifier.name, attributes: .init([.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.tint]))
            
            return cell
        }
        
        collectionView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tamagotchi>()
        snapshot.appendSections([.tamagotchi])
        dataSource.apply(snapshot)
    }
    
    private func bind() {
        let output = viewModel.transform(
            .init(
                model: collectionView.rx.itemSelected(dataSource).asObservable()
            )
        )
        
        output.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.choice
            .drive(with: self) { owner, tamagotchi in
                owner.delegate?.alert(tamagotchi: tamagotchi)
            }
            .disposed(by: disposeBag)
        
        // TODO: 스냅샷에 바인드
        output.items
            .drive(with: self) { owner, items in
                var snapshot = owner.dataSource.snapshot()
                snapshot.appendItems(items, toSection: .tamagotchi)
                owner.dataSource.apply(snapshot)
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
