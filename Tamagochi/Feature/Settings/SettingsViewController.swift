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

struct Settings {
    let image: UIImage?
    let text: String
    let secondaryText: String?
    
    init(image: UIImage?, text: String, secondaryText: String? = nil) {
        self.image = image
        self.text = text
        self.secondaryText = secondaryText
    }
}

final class SettingsViewModel: ViewModel {
    struct Input {
        
    }
    struct Output {
        let settings: Driver<[Settings]>
    }
    
    let settings: [Settings] = [
        .init(image: UIImage(systemName: "pencil"), text: "내 이름 설정하기", secondaryText: "대장"),
        .init(image: UIImage(systemName: "moon.fill"), text: "다마고치 변경하기"),
        .init(image: UIImage(systemName: "goforward"), text: "데이터 초기화")
    ]
    
    func transform(input: Input) -> Output {
        
        
        return .init(settings: Observable.just(settings).asDriver(onErrorJustReturn: []))
    }
}

final class SettingsViewController: TamagochiViewController<SettingsViewModel> {
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: .init())
        
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
