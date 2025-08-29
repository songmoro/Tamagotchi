//
//  SettingsViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsViewModel: ViewModel {
    deinit {
        print(self, #function)
    }
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let row: Observable<Int>
    }
    struct Output {
        let settings: Driver<Settings>
        let nickname: Driver<Void>
        let change: Driver<Tamagotchi>
        let reset: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let rowAction = PublishRelay<Int>()
        let settings = BehaviorRelay<Settings>(value: .nickname(""))
        let account = Container.shared.account
        let nickname = PublishRelay<Void>()
        let change = PublishRelay<Tamagotchi>()
        let reset = PublishRelay<Void>()
        
        input.row
            .bind(to: rowAction)
            .disposed(by: disposeBag)
        
        account
            .compactMap(\.?.nickname)
            .map { nickname -> Settings in
                    .nickname(nickname)
            }
            .bind(to: settings)
            .disposed(by: disposeBag)
        
        rowAction
            .bind {
                if $0 == 0 {
                    nickname.accept(())
                }
                else if $0 == 1 {
                    guard let tamagotchi = account.value?.tamagotchi else { return }
                    change.accept(tamagotchi)
                }
                else if $0 == 2 {
                    reset.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        return .init(
            settings: settings.asDriver(onErrorJustReturn: .nickname("")),
            nickname: nickname.asDriver(onErrorJustReturn: ()),
            change: change.asDriver(onErrorJustReturn: .cactus),
            reset: reset.asDriver(onErrorJustReturn: ())
        )
    }
}
