//
//  BoxOfiiceViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BoxOfiiceViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let text: Observable<String>
        let click: Observable<Void>
    }
    struct Output {
        let movies: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let date = PublishRelay<String>()
        let movies = PublishRelay<String>()
        
        input.click
            .withLatestFrom(input.text)
            .bind(to: date)
            .disposed(by: disposeBag)
        
        date
            .flatMap(BoxOfficeObservable.movie)
            .map(\.boxOfficeResult.dailyBoxOfficeList)
            .map { $0.map(\.movieNm) }
            .map { $0.joined(separator: "\n") }
            .bind(to: movies)
            .disposed(by: disposeBag)
        
        return .init(
            movies: movies.asDriver(onErrorJustReturn: "")
        )
    }
}
