//
//  MainViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModel {
    deinit {
        print(self, #function)
    }
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let bubble: Observable<Void>
        let foodText: Observable<String>
        let foodButtonTap: Observable<Void>
        let waterText: Observable<String>
        let waterButtonTap: Observable<Void>
    }
    struct Output {
        let account: Driver<Account>
        let bubble: Driver<String>
    }
    
    init() { }
    
    func transform(_ input: Input) -> Output {
        let foodInt = BehaviorRelay(value: 0)
        let waterInt = BehaviorRelay(value: 0)
        let bubble = BehaviorRelay(value: "좋은 아침")
        let account = Container.shared.account
        
        input.bubble
            .map {
                String("12345678".randomElement()!)
            }
            .bind(to: bubble)
            .disposed(by: disposeBag)
        
        input.foodText
            .map { $0.isEmpty ? "1" : $0 }
            .map { Int($0) ?? 0 }
            .bind(to: foodInt)
            .disposed(by: disposeBag)
        
        input.foodButtonTap
            .withLatestFrom(foodInt)
            .filter { 1..<100 ~= $0 }
            .withLatestFrom(account) {
                var newAccount = $1
                newAccount?.food += $0
                
                return newAccount
            }
            .bind(to: account)
            .disposed(by: disposeBag)
        
        input.waterText
            .map { $0.isEmpty ? "1" : $0 }
            .map { Int($0) ?? 0 }
            .bind(to: waterInt)
            .disposed(by: disposeBag)
        
        input.waterButtonTap
            .withLatestFrom(waterInt)
            .filter { 1..<50 ~= $0 }
            .withLatestFrom(account) {
                var newAccount = $1
                newAccount?.water += $0
                
                return newAccount
            }
            .bind(to: account)
            .disposed(by: disposeBag)
        
        return .init(
            account: account.compactMap(\.self).asDriver(onErrorJustReturn: .init(tamagotchi: .cactus)),
            bubble: bubble.asDriver()
        )
    }
}
