//
//  SettingsViewController.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingsViewController: TamagochiViewController<SettingsViewModel> {
    private let mainViewModel: MainViewModel
    private let tableView = UITableView()
    
    init(viewModel: SettingsViewModel, mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        super.init(viewModel: viewModel)
    }
    
    @available(*, deprecated)
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
            input: .init(
                nickname: mainViewModel.share.nickname.asObservable(),
                row: tableView.rx.itemSelected.map(\.row).asObservable()
            )
        )
        
        output.settings
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) {
                var configuration = UITableViewCell(style: .value2, reuseIdentifier: nil).defaultContentConfiguration()
                configuration.text = $1.text
                configuration.image = $1.image
                configuration.secondaryText = $1.secondaryText
                
                $2.contentConfiguration = configuration
                $2.tintColor = .tint
                $2.backgroundColor = .clear
                $2.accessoryType = .disclosureIndicator
            }
            .disposed(by: disposeBag)
        
        output.change
            .drive(with: self) { owner, _ in
                let vc = NicknameViewController(viewModel: .init(), mainViewModel: owner.mainViewModel)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.choice
            .drive(with: self) { owner, _ in
                let vc = ChoiceViewController(mainViewModel: owner.mainViewModel)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.reset
            .drive(with: self) { owner, _ in
                let alert = UIAlertController(title: "데이터 초기화", message: "정말 다시 처음부터 시작하실 건가용?", preferredStyle: .alert)
                alert.addAction(.init(title: "아냐!", style: .cancel))
                alert.addAction(.init(title: "웅", style: .destructive, handler: { _ in
                    UserDefaults.standard.set(nil, forKey: "tamagotchi")
                    
                    let vc = ChoiceViewController(viewModel: .init())
                    (owner.view.window?.rootViewController as? UINavigationController)?.viewControllers = [vc]
                }))
                
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        navigationItem.title = "설정"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview(\.safeAreaLayoutGuide)
        }
        
        tableView.backgroundColor = .background
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}
