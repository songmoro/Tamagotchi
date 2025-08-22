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

import UIKit

protocol IsIdentifiable {
    static var identifier: String { get }
}

extension IsIdentifiable {
    static var identifier: String {
        String(describing: Self.self)
    }
}

extension UITableView {
    func register<T: UITableViewCell & IsIdentifiable>(_ cellClass: T.Type) {
        self.register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell & IsIdentifiable>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withIdentifier: cellClass.identifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell & IsIdentifiable>(_ cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell & IsIdentifiable>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withReuseIdentifier: cellClass.identifier, for: indexPath) as! T
    }
}

final class ChoiceCollectionViewCell: UICollectionViewCell, IsIdentifiable {
    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        label.text = "31232132"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ChoiceViewModel: ViewModel {
    let data: [ImageResource] = [._1_6, ._2_6, ._3_6] + Array(repeating: .no, count: 20)
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
        collectionView.collectionViewLayout = layout(collectionView)
    }
    
    private func bind() {
        Observable.just(viewModel.data)
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: "ChoiceCollectionViewCell", cellType: ChoiceCollectionViewCell.self)) {
                $2.imageView.image = UIImage(resource: $1)
            }
            .disposed(by: disposeBag)
    }
    
    private func layout(_ collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 150)
        layout.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        return layout
    }
}
