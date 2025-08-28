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
        
        output.account
            .map(\.nickname)
            .drive(nicknameTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        output.dismiss
            .drive(with: self) { owner, _ in
                owner.delegate?.finish()
//                owner.mainViewModel.share.nickname.accept(nickname)
//                owner.navigationController?.popViewController(animated: true)
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
