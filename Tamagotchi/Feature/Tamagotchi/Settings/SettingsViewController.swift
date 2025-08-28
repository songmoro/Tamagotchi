//
//  SettingsViewController.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingsViewController: ViewController<SettingsViewModel> {
    var delegate: SettingsViewControllerDelegate?
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(
            input: .init(
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
        
        output.nickname
            .drive(with: self) { owner, _ in
                owner.delegate?.nickname()
            }
            .disposed(by: disposeBag)
        
        output.change
            .drive(with: self) { owner, tamagotchi in
                owner.delegate?.change(tamagotchi: tamagotchi)
            }
            .disposed(by: disposeBag)
        
        output.reset
            .drive(with: self) { owner, _ in
                owner.delegate?.reset {
                    Container.shared.update(nil)
                }
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
