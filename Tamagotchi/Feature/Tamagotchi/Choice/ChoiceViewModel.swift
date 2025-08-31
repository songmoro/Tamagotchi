//
//  ChoiceViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/22/25.
//

import RxSwift
import RxCocoa

final class ChoiceViewModel: ViewModel {
    enum Mode {
        case choice
        case change
    }
    
    deinit {
        print(self, #function)
    }
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let model: Observable<Tamagotchi>
    }
    struct Output {
        let title: Driver<String>
        let items: Driver<[Tamagotchi]>
        let choice: Driver<Tamagotchi>
    }
    
    private let mode: Mode
    private let items: [Tamagotchi] = Tamagotchi.allCases
    
    init(mode: Mode) {
        self.mode = mode
    }
    
    func transform(_ input: Input) -> Output {
        let items = Observable.just(items)
        let choice = PublishRelay<Tamagotchi>()
        let title = Observable.just(mode)
            .map {
                switch $0 {
                case .choice:
                    "다마고치 선택하기"
                case .change:
                    "다마고치 변경하기"
                }
            }
        
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
