//
//  AlertViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class AlertViewModel: ViewModel {
    deinit {
        print(self, #function)
    }
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let cancelTap: Observable<Void>
        let acceptTap: Observable<Void>
    }
    struct Output {
        let acceptTitle: Driver<String>
        let dismiss: Driver<Void>
        let start: Driver<Void>
        let change: Driver<Void>
    }
    
    let tamagotchi: Tamagotchi
    
    init(tamagotchi: Tamagotchi) {
        self.tamagotchi = tamagotchi
    }
    
    func transform(_ input: Input) -> Output {
        let isChange = Container.shared.account.value != nil
        let acceptTitle = Observable.just(isChange)
            .map { $0 ? "변경하기" : "시작하기" }
        let dismiss = PublishSubject<Void>()
        let acceptTap = input.acceptTap.share()
        let start = PublishSubject<Void>()
        let change = PublishSubject<Void>()
        
        Observable.merge(input.cancelTap, acceptTap)
            .bind(to: dismiss)
            .disposed(by: disposeBag)
        
        acceptTap
            .map { [tamagotchi] _ -> Bool in
                Container.shared.account.accept(Account(tamagotchi: tamagotchi))
                return isChange
            }
            .bind {
                if $0 {
                    change.onNext(())
                }
                else {
                    start.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        return .init(
            acceptTitle: acceptTitle.asDriver(onErrorJustReturn: "시작하기"),
            dismiss: dismiss.asDriver(onErrorJustReturn: ()),
            start: start.asDriver(onErrorJustReturn: ()),
            change: change.asDriver(onErrorJustReturn: ())
        )
    }
}
