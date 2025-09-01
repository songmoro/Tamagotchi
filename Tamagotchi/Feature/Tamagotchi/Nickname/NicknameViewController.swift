//
//  NicknameViewController.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NicknameViewController: ViewController<NicknameViewModel> {
    var delegate: NicknameViewControllerDelegate?
    
    private let nicknameTextField = UnderlineTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        react()
    }
    
    private func react() {
        navigationItem.rightBarButtonItem?.rx.tap
            .withLatestFrom(nicknameTextField.rx.text.orEmpty)
            .map(NicknameViewModel.Action.text)
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        viewModel.state.compactMap(\.account?.nickname)
            .drive(nicknameTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.state.compactMap(\.dismiss)
            .drive(with: self) { owner, _ in
                owner.delegate?.finish()
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
    }
}
