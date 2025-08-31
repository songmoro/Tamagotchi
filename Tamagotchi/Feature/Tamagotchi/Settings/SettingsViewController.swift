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
    
    var dataSource: UITableViewDiffableDataSource<Section, Settings>!
    
    enum Section: Int {
        case nickname
        case tamagotchi
        case reset
    }
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
//        bind()
        react()
    }
    
    private func react() {
        tableView.rx.itemSelected
            .map(\.section)
            .map(SettingsViewModel.Action.tap(row:))
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        viewModel.state.map(\.settings)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .nickname(""))
            .drive(with: self) { owner, settings in
                var snapshot = owner.dataSource.snapshot()
                snapshot.appendItems([settings], toSection: .nickname)
                owner.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
        
        viewModel.state.map(\.transition)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .compactMap(\.self)
            .drive(with: self) { owner, transition in
                switch transition {
                case .nickname:
                    owner.delegate?.nickname()
                case .tamagotchi:
                    owner.delegate?.change(tamagotchi: .preparing)
                case .reset:
                    owner.delegate?.reset {
                        Container.shared.account.accept(nil)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.action
            .bind(to: .init(value: .`init`))
            .disposed(by: disposeBag)
    }
    
//    private func bind() {
//        let output = viewModel.transform(
//            input: .init(
//                row: tableView.rx.itemSelected.map(\.section).asObservable()
//            )
//        )
//        
//        output.settings
//            .drive(with: self) { owner, settings in
//                var snapshot = owner.dataSource.snapshot()
//                snapshot.appendItems([settings], toSection: .nickname)
//                owner.dataSource.apply(snapshot)
//            }
//            .disposed(by: disposeBag)
//        
//        output.nickname
//            .drive(with: self) { owner, _ in
//                owner.delegate?.nickname()
//            }
//            .disposed(by: disposeBag)
//        
//        output.change
//            .drive(with: self) { owner, tamagotchi in
//                owner.delegate?.change(tamagotchi: tamagotchi)
//            }
//            .disposed(by: disposeBag)
//        
//        output.reset
//            .drive(with: self) { owner, _ in
//                owner.delegate?.reset {
//                    Container.shared.account.accept(nil)
//                }
//            }
//            .disposed(by: disposeBag)
//    }
    
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
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            var configuration = UITableViewCell(style: .value2, reuseIdentifier: nil).defaultContentConfiguration()
            configuration.text = itemIdentifier.text
            configuration.image = itemIdentifier.image
            configuration.secondaryText = itemIdentifier.secondaryText
            
            cell.contentConfiguration = configuration
            cell.tintColor = .tint
            cell.backgroundColor = .clear
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        
        tableView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Settings>()
        snapshot.appendSections([.nickname, .tamagotchi, .reset])
        snapshot.appendItems([.tamagotchi], toSection: .tamagotchi)
        snapshot.appendItems([.reset], toSection: .reset)
        dataSource.apply(snapshot)
    }
}
