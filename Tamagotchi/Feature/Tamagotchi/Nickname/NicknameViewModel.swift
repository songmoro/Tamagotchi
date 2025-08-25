//
//  NicknameViewModel.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let text: Observable<String>
        let tap: Observable<Void>
    }
    struct Output {
        let dismiss: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let dismiss = PublishRelay<String>()
        
        input.tap
            .withLatestFrom(input.text)
            .filter { 2...6 ~= $0.count }
            .bind(to: dismiss)
            .disposed(by: disposeBag)
        
        return .init(dismiss: dismiss.asDriver(onErrorJustReturn: ""))
    }
}
