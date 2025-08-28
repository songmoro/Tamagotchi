//
//  ChoiceViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/22/25.
//

import RxSwift
import RxCocoa

final class ChoiceViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let model: Observable<Tamagotchi>
    }
    struct Output {
        let title: Driver<String>
        let items: Driver<[Tamagotchi]>
        let choice: Driver<Tamagotchi>
    }
    
    private let tamagotchi: Tamagotchi?
    private let items: [Tamagotchi] = Tamagotchi.allCases
    
    init(tamagotchi: Tamagotchi? = nil) {
        self.tamagotchi = tamagotchi
    }
    
    func transform(_ input: Input) -> Output {
        let items = Observable.just(items)
        let choice = PublishRelay<Tamagotchi>()
        let title = Observable.just(tamagotchi == nil)
            .map { $0 ? "다마고치 선택하기" : "다마고치 변경하기" }
        
        input.model
            .bind(to: choice)
            .disposed(by: disposeBag)
        
        return .init(
            title: title.asDriver(onErrorJustReturn: "다마고치 선택하기"),
            items: items.asDriver(onErrorJustReturn: []),
            choice: choice.asDriver(onErrorJustReturn: .cactus),
        )
    }
}
