//
//  ChangeAlertViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/23/25.
//

import RxSwift
import RxCocoa

final class ChangeAlertViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let cancelTap: Observable<Void>
        let acceptTap: Observable<Void>
    }
    struct Output {
        let dismiss: Driver<Void>
        let change: Driver<Tamagotchi>
    }
    
    func transform(_ input: Input) -> Output {
        let dismiss = PublishSubject<Void>()
        let acceptTap = input.acceptTap.share()
        let change = BehaviorRelay(value: Container.shared.account?.tamagotchi)
        
        Observable.merge(input.cancelTap, acceptTap)
            .bind(to: dismiss)
            .disposed(by: disposeBag)
        
        acceptTap
            .withLatestFrom(change)
//            .compactMap { (owner, account) -> Account? in
//                let tamagotchi = account. .tamagotchi
//                
//                return Account(tamagotchi: tamagotchi)
//            }
            .bind(to: change)
            .disposed(by: disposeBag)
        
        return .init(
            dismiss: dismiss.asDriver(onErrorJustReturn: ()),
            change: change.compactMap(\.self).asDriver(onErrorJustReturn: .cactus)
        )
    }
}
