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
    private let disposeBag = DisposeBag()
    
    struct Input {
        let cancelTap: Observable<Void>
        let acceptTap: Observable<Void>
    }
    struct Output {
        let isChange: Driver<String>
        let dismiss: Driver<Void>
        let start: Driver<Void>
    }
    
    let tamagotchi: Tamagotchi
    
    init(tamagotchi: Tamagotchi) {
        self.tamagotchi = tamagotchi
    }
    
    func transform(_ input: Input) -> Output {
        let isChange = Observable.just(Container.shared.account != nil)
            .map { $0 ? "변경하기" : "시작하기" }
        let dismiss = PublishSubject<Void>()
        let acceptTap = input.acceptTap.share()
        let start = PublishSubject<Void>()
        
        Observable.merge(input.cancelTap, acceptTap)
            .bind(to: dismiss)
            .disposed(by: disposeBag)
        
        acceptTap
            .do(onNext: { [tamagotchi] in
                let account = Account(tamagotchi: tamagotchi)
                Container.shared.update(account)
            })
            .bind(to: start)
            .disposed(by: disposeBag)
        
        return .init(
            isChange: isChange.asDriver(onErrorJustReturn: "시작하기"),
            dismiss: dismiss.asDriver(onErrorJustReturn: ()),
            start: start.asDriver(onErrorJustReturn: ())
        )
    }
}
