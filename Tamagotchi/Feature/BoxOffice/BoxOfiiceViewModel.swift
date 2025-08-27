//
//  BoxOfiiceViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/25/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

enum Loadable<Data, Result, Error> {
    case notLoaded
    case isLoading(Data)
    case loaded(Result)
    case failed(Error)
}

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
        let alert = PublishRelay<String>()
        let toast = PublishRelay<String>()
        let loadableResponse = PublishRelay<Loadable<String, BoxOfficeResponse, Error>>()
        
        input.click
            .withLatestFrom(input.text)
            .bind(to: date)
            .disposed(by: disposeBag)
        
        date
            .bind {
                loadableResponse.accept(.isLoading($0))
            }
            .disposed(by: disposeBag)
        
        // TODO: 중복 요청 시도
        loadableResponse
            .bind { loadable in
                switch loadable {
                case .notLoaded:
                    movies.accept("영화 제목1\n영화 제목2")
                case .isLoading(let date):
                    movies.accept("영화를 불러오는 중 입니다...")
                    
                    Task {
                        guard NetworkMonitor.shared.isConnected else {
                            throw LocalizedErrorReason(message: "네트워크 요청에 실패했습니다.")
                        }
                        
                        let url = URL(string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json")!
                        let parameters = BoxOfficeParameters(key: Secret.boxOfficeApiKey, targetDt: date)
                        
                        do {
                            let response = try await AF.request(url, parameters: parameters).serializingDecodable(BoxOfficeResponse.self).value
                            loadableResponse.accept(.loaded(response))
                        }
                        catch {
                            loadableResponse.accept(.failed(error))
                        }
                    }
                    
                case .loaded(let response):
                    let result = response.boxOfficeResult.dailyBoxOfficeList
                        .map(\.movieNm)
                        .joined(separator: ", ")
                    
                    movies.accept(result)
                case .failed(let error):
                    if let error = error as? LocalizedError, let message = error.errorDescription {
                        if error is BoxOfficeObservable.ErrorReason {
                            alert.accept(message)
                        }
                        else if error is LocalizedErrorReason {
                            toast.accept(message)
                        }
                        
                        movies.accept(message)
                    }
                    else {
                        movies.accept("잘못된 요청입니다.")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return .init(
            movies: movies.asDriver(onErrorJustReturn: ""),
            alert: alert.asDriver(onErrorJustReturn: ""),
            toast: toast.asDriver(onErrorJustReturn: "")
        )
    }
}
