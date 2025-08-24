//
//  MainViewModel.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Share {
        let save: BehaviorRelay<TamagochiCharacter>
        let character: BehaviorRelay<TamagochiCharacter>
    }
    struct Input {
        let foodText: Observable<String>
        let foodButtonTap: Observable<Void>
        let waterText: Observable<String>
        let waterButtonTap: Observable<Void>
    }
    struct Output {
        let nickname: Driver<String>
        let character: Driver<TamagochiCharacter>
    }
    
    let share: Share
    let nickname: String
//    let character: TamagochiCharacter
    
    init(nickname: String = "대장", character: TamagochiCharacter) {
        self.nickname = nickname
        self.share = Share(
            save: BehaviorRelay(value: character),
            character: BehaviorRelay(value: character)
        )
        
        bind()
    }
    
    private func bind() {
        share.save
            .do(onNext: {
                let data = try? PropertyListEncoder().encode($0)
                UserDefaults.standard.set(data, forKey: "tamagochi")
            })
            .bind(to: share.character)
            .disposed(by: disposeBag)
    }
    
    func transform(_ input: Input) -> Output {
        let foodInt = BehaviorRelay(value: 0)
        let waterInt = BehaviorRelay(value: 0)
        
        let nickname = BehaviorRelay(value: self.nickname)
//        let character = BehaviorRelay(value: self.character)
//        let save = BehaviorRelay(value: self.character)
        
        input.foodText
            .map { Int($0) ?? 0}
            .bind(to: foodInt)
            .disposed(by: disposeBag)
        
        input.foodButtonTap
            .withLatestFrom(foodInt)
            .filter { 1..<100 ~= $0 }
            .withLatestFrom(share.character) {
                var newCharacter = $1
                newCharacter.food += $0
                
                return newCharacter
            }
            .bind(to: share.save)
            .disposed(by: disposeBag)
        
        input.waterText
            .map { Int($0) ?? 0}
            .bind(to: waterInt)
            .disposed(by: disposeBag)
        
        input.waterButtonTap
            .withLatestFrom(waterInt)
            .filter { 1..<50 ~= $0 }
            .withLatestFrom(share.character) {
                var newCharacter = $1
                newCharacter.water += $0
                
                return newCharacter
            }
            .bind(to: share.save)
            .disposed(by: disposeBag)
        
        return .init(nickname: nickname.asDriver(), character: share.character.asDriver())
    }
}
