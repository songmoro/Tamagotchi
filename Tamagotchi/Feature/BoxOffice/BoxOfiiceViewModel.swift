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
        let response = PublishRelay<BoxOfficeResponse>()
        let errorRelay = PublishRelay<Error>()
        
        input.click
            .withLatestFrom(input.text)
            .bind(to: date)
            .disposed(by: disposeBag)
        
        date
            .do(onNext: { _ in movies.accept("영화를 불러오는 중 입니다...") })
            .flatMap(BoxOfficeObservable.movie)
            .debug()
            .bind {
                switch $0 {
                case .success(let result):
                    response.accept(result)
                case .failure(let error):
                    errorRelay.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        response
            .map(\.boxOfficeResult.dailyBoxOfficeList)
            .map { $0.map(\.movieNm) }
            .map { $0.joined(separator: "\n") }
            .bind(to: movies)
            .disposed(by: disposeBag)
        
        errorRelay
            .map { ($0 as? LocalizedError)?.errorDescription ?? "잘못된 요청입니다." }
            .bind(to: movies)
            .disposed(by: disposeBag)
        
        return .init(
            movies: movies.asDriver(onErrorJustReturn: "")
        )
    }
}
