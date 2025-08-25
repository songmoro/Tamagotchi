//
//  LotteryViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LotteryViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let text: Observable<String>
        let click: Observable<Void>
    }
    struct Output {
        let lotto: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let no = PublishRelay<Int>()
        let lotto = PublishRelay<String>()
        
        input.click
            .withLatestFrom(input.text)
            .compactMap(Int.init)
            .filter { 1...1186 ~= $0 }
            .bind(to: no)
            .disposed(by: disposeBag)
        
        no
            .flatMap(LottoObservable.lottery(no:))
            .map { [$0.drwtNo1, $0.drwtNo2, $0.drwtNo3, $0.drwtNo4, $0.drwtNo5, $0.drwtNo6, $0.bnusNo] }
            .map { $0.map(\.description).joined(separator: ", ") }
            .bind(to: lotto)
            .disposed(by: disposeBag)
        
        return .init(
            lotto: lotto.asDriver(onErrorJustReturn: "")
        )
    }
}
