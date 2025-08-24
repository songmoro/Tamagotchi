//
//  NicknameViewController.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NicknameViewController: TamagochiViewController<NicknameViewModel> {
    private let mainViewModel: MainViewModel
    let nicknameTextField = UITextField()
    
    init(viewModel: NicknameViewModel, mainViewModel: MainViewModel) {
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
        guard let barButtonItem = navigationItem.rightBarButtonItem else { return }
        
        let output = viewModel.transform(
            .init(
                text: nicknameTextField.rx.text.orEmpty.asObservable(),
                tap: barButtonItem.rx.tap.asObservable()
            )
        )
        
        output.dismiss
            .drive(with: self) { owner, nickname in
                owner.mainViewModel.share.nickname.accept(nickname)
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        navigationItem.title = "대장님 이름 정하기"
        navigationItem.rightBarButtonItem = .init(title: "저장", style: .plain, target: nil, action: nil)
        
        view.addSubview(nicknameTextField)
        
        nicknameTextField.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide).inset(20)
        }
        
        nicknameTextField.placeholder = mainViewModel.share.nickname.value
    }
}
