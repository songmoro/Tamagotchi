//
//  AlertViewModel.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/23/25.
//

import RxSwift
import RxCocoa

final class AlertViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let cancelTap: Observable<Void>
        let acceptTap: Observable<Void>
    }
    struct Output {
        let dismiss: Driver<Void>
        let start: Driver<TamagochiCharacter>
    }
    
    let tamagotchi: Tamagochi
    
    init(tamagotchi: Tamagochi) {
        self.tamagotchi = tamagotchi
    }
    
    func transform(_ input: Input) -> Output {
        let dismiss = PublishSubject<Void>()
        let acceptTap = input.acceptTap.share()
        let start = PublishSubject<TamagochiCharacter>()
        
        Observable.merge(input.cancelTap, acceptTap)
            .bind(to: dismiss)
            .disposed(by: disposeBag)
        
        acceptTap
            .withUnretained(self)
            .compactMap { (owner, _) -> TamagochiCharacter? in
                let tamagotchi = owner.tamagotchi
                
                return TamagochiCharacter(tamagotchi: tamagotchi)
            }
            .bind(to: start)
            .disposed(by: disposeBag)
        
        return .init(
            dismiss: dismiss.asDriver(onErrorJustReturn: ()),
            start: start.asDriver(onErrorJustReturn: .init(tamagotchi: .preparing))
        )
    }
}
