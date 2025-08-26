//
//  LottoObservable.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/25/25.
//

import Foundation
import Alamofire
import RxSwift

final class LottoObservable {
    private init() { }
    
    enum LottoError: LocalizedError {
        case under
        case over
        case string
        case network
        
        var errorDescription: String? {
            switch self {
            case .under:
                "로또 회차는 1회 이상입니다."
            case .over:
                "로또 회차는 1186회 이하입니다."
            case .string:
                "로또 회차는 숫자입니다."
            case .network:
                "네트워크 연결이 불안정합니다."
            }
        }
    }
    
    static func lottery(no: Int) -> Observable<Result<Lotto, Error>> {
        return Observable.create { observer in
            guard let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(no)") else {
                return Disposables.create()
            }
            
            AF.request(url)
                .responseDecodable(of: Lotto.self) { response in
                    switch response.result {
                    case .success(let lotto):
                        observer.onNext(.success(lotto))
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onNext(.failure(error))
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
    }
}
