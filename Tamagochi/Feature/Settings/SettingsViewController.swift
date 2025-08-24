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
    private let disposeBag = DisposeBag()
    
    struct Input {
        let row: Observable<Int>
    }
    struct Output {
        let settings: Driver<[Settings]>
        let reset: Driver<Void>
    }
    
    let settings: [Settings] = [
        .init(image: UIImage(systemName: "pencil"), text: "내 이름 설정하기", secondaryText: "대장"),
        .init(image: UIImage(systemName: "moon.fill"), text: "다마고치 변경하기"),
        .init(image: UIImage(systemName: "goforward"), text: "데이터 초기화")
    ]
    
    func transform(input: Input) -> Output {
        let rowAction = PublishRelay<Int>()
        let reset = PublishRelay<Void>()
        
        input.row
            .bind(to: rowAction)
            .disposed(by: disposeBag)
        
        rowAction
            .bind {
                if $0 == 0 {
                    
                }
                else if $0 == 1 {
                    
                }
                else if $0 == 2 {
                    reset.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        return .init(settings: Observable.just(settings).asDriver(onErrorJustReturn: []), reset: reset.asDriver(onErrorJustReturn: ()))
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
        
        output.reset
            .drive(with: self) { owner, _ in
                let alert = UIAlertController(title: "데이터 초기화", message: "정말 다시 처음부터 시작하실 건가용?", preferredStyle: .alert)
                alert.addAction(.init(title: "아냐!", style: .cancel))
                alert.addAction(.init(title: "웅", style: .destructive, handler: { _ in
                    UserDefaults.standard.set(nil, forKey: "tamagochi")
                    
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
