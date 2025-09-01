//
//  LotteryViewController.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LotteryViewController: ViewController<LotteryViewModel, EmptyViewControllerDelegate> {
    private let searchBar = UISearchBar()
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(
            .init(
                text: searchBar.rx.text.orEmpty.asObservable(),
                click: searchBar.rx.searchButtonClicked.asObservable()
            )
        )
        
        output.lotto
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        output.alert
            .drive(with: self) {
                $0.showAlert($1)
            }
            .disposed(by: disposeBag)
        
        output.toast
            .drive(with: self) {
                $0.showToast($1)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        [searchBar, label].forEach(view.addSubview)
        
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide).inset(12)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide)
        }
        
        searchBar.searchBarStyle = .prominent
        label.text = "0, 0, 0, 0, 0, 0, 0"
    }
}
