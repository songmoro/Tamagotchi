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
    
    let nickname: String
    let character: TamagochiCharacter
    
    init(nickname: String = "대장", character: TamagochiCharacter) {
        self.nickname = nickname
        self.character = character
    }
    
    func transform(_ input: Input) -> Output {
        let foodInt = BehaviorRelay(value: 0)
        let waterInt = BehaviorRelay(value: 0)
        
        let nickname = BehaviorRelay(value: self.nickname)
        let character = BehaviorRelay(value: self.character)
        let save = BehaviorRelay(value: self.character)
        
        input.foodText
            .map { Int($0) ?? 0}
            .bind(to: foodInt)
            .disposed(by: disposeBag)
        
        input.foodButtonTap
            .withLatestFrom(foodInt)
            .filter { 1..<100 ~= $0 }
            .withLatestFrom(character) {
                var newCharacter = $1
                newCharacter.food += $0
                
                return newCharacter
            }
            .bind(to: save)
            .disposed(by: disposeBag)
        
        input.waterText
            .map { Int($0) ?? 0}
            .bind(to: waterInt)
            .disposed(by: disposeBag)
        
        input.waterButtonTap
            .withLatestFrom(waterInt)
            .filter { 1..<50 ~= $0 }
            .withLatestFrom(character) {
                var newCharacter = $1
                newCharacter.water += $0
                
                return newCharacter
            }
            .bind(to: save)
            .disposed(by: disposeBag)
        
        save
            .do(onNext: {
                let data = try? PropertyListEncoder().encode($0)
                UserDefaults.standard.set(data, forKey: "tamagochi")
            })
            .bind(to: character)
            .disposed(by: disposeBag)
        
        return .init(nickname: nickname.asDriver(), character: character.asDriver())
    }
}
