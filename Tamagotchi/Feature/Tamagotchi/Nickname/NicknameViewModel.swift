//
//  NicknameViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let text: Observable<String>
        let tap: Observable<Void>
    }
    struct Output {
        let account: Driver<Account>
        let dismiss: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let dismiss = PublishRelay<String>()
        let account = BehaviorRelay<Account?>(value: Container.shared.account)
        
        input.tap
            .withLatestFrom(input.text)
            .filter { 2...6 ~= $0.count }
            .do(onNext: {
                guard var account = account.value else { return }
                account.nickname = $0
                
                Container.shared.update(account)
            })
            .bind(to: dismiss)
            .disposed(by: disposeBag)
        
        return .init(
            account: account.compactMap(\.self).asDriver(onErrorJustReturn: .init(tamagotchi: .cactus)),
            dismiss: dismiss.asDriver(onErrorJustReturn: "")
        )
    }
}
