//
//  LotteryViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/25/25.
//

import Foundation
import Alamofire
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
        let alert: Driver<String>
        let toast: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let no = PublishRelay<Int?>()
        let response = PublishRelay<Lotto>()
        let errorRelay = PublishRelay<Error>()
        let lotto = PublishRelay<String>()
        let alert = PublishRelay<String>()
        let toast = PublishRelay<String>()
        
        input.click
            .withLatestFrom(input.text)
            .map(Int.init)
            .bind(to: no)
            .disposed(by: disposeBag)
        
        // TODO: 이벤트를 한 번만 방출하는 문제 해결
        no
            .withLatestFrom(NetworkStatus.shared.statusSubject) {
                return ($0, $1)
            }
            .compactMap { (no, network) in
                guard case .connect = network else {
                    errorRelay.accept(LottoObservable.LottoError.network)
                    alert.accept(LottoObservable.LottoError.network.errorDescription!)
                    return nil
                }
                guard let no else {
                    errorRelay.accept(LottoObservable.LottoError.string)
                    return nil
                }
                guard no >= 1 else {
                    errorRelay.accept(LottoObservable.LottoError.under)
                    return nil
                }
                guard no <= 1186 else {
                    errorRelay.accept(LottoObservable.LottoError.over)
                    return nil
                }
                
                return no
            }
            .flatMap(LottoObservable.lottery(no:))
            .bind {
                switch $0 {
                case .success(let lotto):
                    response.accept(lotto)
                case .failure:
                    errorRelay.accept(LocalizedErrorReason(message: "네트워크 요청에 실패했습니다."))
                    toast.accept(LocalizedErrorReason(message: "네트워크 요청에 실패했습니다.").errorDescription!)
                }
            }
            .disposed(by: disposeBag)
        
        response
            .map { [$0.drwtNo1, $0.drwtNo2, $0.drwtNo3, $0.drwtNo4, $0.drwtNo5, $0.drwtNo6, $0.bnusNo] }
            .map { $0.map(\.description).joined(separator: ", ") }
            .bind(to: lotto)
            .disposed(by: disposeBag)
        
        errorRelay
            .map {
                ($0 as? LocalizedError)?.errorDescription ?? "잘못된 요청입니다."
            }
            .bind(to: lotto)
            .disposed(by: disposeBag)
        
        return .init(
            lotto: lotto.asDriver(onErrorJustReturn: ""),
            alert: alert.asDriver(onErrorJustReturn: ""),
            toast: toast.asDriver(onErrorJustReturn: "")
        )
    }
}
