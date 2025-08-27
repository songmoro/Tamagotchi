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
        let alert: Driver<String>
        let toast: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let date = PublishRelay<String>()
        let movies = PublishRelay<String>()
        let response = PublishRelay<BoxOfficeResponse>()
        let errorRelay = PublishRelay<Error>()
        let alert = PublishRelay<String>()
        let toast = PublishRelay<String>()
        
        input.click
            .withLatestFrom(input.text)
            .bind(to: date)
            .disposed(by: disposeBag)
        
        date
            .do(onNext: { _ in movies.accept("영화를 불러오는 중 입니다...") })
            .compactMap { date in
                guard NetworkMonitor.shared.isConnected else {
                    errorRelay.accept(LocalizedErrorReason(message: "네트워크 요청에 실패했습니다."))
                    alert.accept(LocalizedErrorReason(message: "네트워크 요청에 실패했습니다.").errorDescription!)
                    return nil
                }
                
                return date
            }
            .flatMap(BoxOfficeObservable.movie)
            .bind {
                switch $0 {
                case .success(let result):
                    response.accept(result)
                case .failure:
                    errorRelay.accept(LocalizedErrorReason(message: "잘못된 요청입니다."))
                    toast.accept(LocalizedErrorReason(message: "잘못된 요청입니다.").errorDescription!)
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
            movies: movies.asDriver(onErrorJustReturn: ""),
            alert: alert.asDriver(onErrorJustReturn: ""),
            toast: toast.asDriver(onErrorJustReturn: "")
        )
    }
}
