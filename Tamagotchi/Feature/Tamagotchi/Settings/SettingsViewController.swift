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

final class SettingsViewController: ViewController<SettingsViewModel, SettingsCoordinator> {
    enum Section: Int {
        case nickname
        case tamagotchi
        case reset
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    private var dataSource: UITableViewDiffableDataSource<Section, Settings>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureDataSource()
        react()
    }
    
    private func react() {
        tableView.rx.sectionSelected(dataSource)
            .map(SettingsViewModel.Action.section)
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        viewModel.state.map(\.settings)
            .distinctUntilChanged()
            .drive(with: self) { owner, settings in
                owner.applySnapshot(nickname: settings)
            }
            .disposed(by: disposeBag)
        
        viewModel.state.map(\.section)
            .distinctUntilChanged()
            .compactMap(\.self)
            .drive(with: self) {
                $0.delegate?.section($1)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        navigationItem.title = "설정"
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview(\.safeAreaLayoutGuide)
        }
        
        tableView.dataSource = dataSource
    }
    
    private func configureDataSource() {
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
    }
    
    private func applySnapshot(nickname: Settings) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Settings>()
        snapshot.appendSections([.nickname, .tamagotchi, .reset])
        snapshot.appendItems([nickname], toSection: .nickname)
        snapshot.appendItems([.tamagotchi], toSection: .tamagotchi)
        snapshot.appendItems([.reset], toSection: .reset)
        dataSource.apply(snapshot)
    }
}
