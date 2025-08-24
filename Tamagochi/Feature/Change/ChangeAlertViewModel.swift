//
//  ChangeAlertViewModel.swift
//  Tamagochi
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
        let change: Driver<TamagochiCharacter>
    }
    
    let tamagochi: Tamagochi
    
    init(tamagochi: Tamagochi) {
        self.tamagochi = tamagochi
    }
    
    func transform(_ input: Input) -> Output {
        let dismiss = PublishSubject<Void>()
        let acceptTap = input.acceptTap.share()
        let change = PublishSubject<TamagochiCharacter>()
        
        Observable.merge(input.cancelTap, acceptTap)
            .bind(to: dismiss)
            .disposed(by: disposeBag)
        
        acceptTap
            .withUnretained(self)
            .compactMap { (owner, _) -> TamagochiCharacter? in
                let tamagochi = owner.tamagochi
                
                return TamagochiCharacter(tamagochi: tamagochi)
            }
            .bind(to: change)
            .disposed(by: disposeBag)
        
        return .init(
            dismiss: dismiss.asDriver(onErrorJustReturn: ()),
            change: change.asDriver(onErrorJustReturn: .init(tamagochi: .preparing))
        )
    }
}
