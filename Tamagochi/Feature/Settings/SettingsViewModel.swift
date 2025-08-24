//
//  SettingsViewModel.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nickname: Observable<String>
        let row: Observable<Int>
    }
    struct Output {
        let settings: Driver<[Settings]>
        let change: Driver<Void>
        let choice: Driver<Void>
        let reset: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let rowAction = PublishRelay<Int>()
        let settings = BehaviorRelay<[Settings]>(value: [])
        let change = PublishRelay<Void>()
        let choice = PublishRelay<Void>()
        let reset = PublishRelay<Void>()
        
        input.row
            .bind(to: rowAction)
            .disposed(by: disposeBag)
        
        input.nickname
            .map { nickname -> [Settings] in
                Settings.makeSettings(nickname)
            }
            .bind(to: settings)
            .disposed(by: disposeBag)
        
        rowAction
            .bind {
                if $0 == 0 {
                    change.accept(())
                }
                else if $0 == 1 {
                    choice.accept(())
                }
                else if $0 == 2 {
                    reset.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        return .init(
            settings: settings.asDriver(onErrorJustReturn: []),
            change: change.asDriver(onErrorJustReturn: ()),
            choice: choice.asDriver(onErrorJustReturn: ()),
            reset: reset.asDriver(onErrorJustReturn: ())
        )
    }
}
