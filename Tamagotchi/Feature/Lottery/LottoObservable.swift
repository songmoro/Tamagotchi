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
    
    static func lottery(no: Int) -> Observable<Lotto> {
        return Observable.create { observer in
            guard let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(no)") else {
                return Disposables.create()
            }
            
            AF.request(url)
                .responseDecodable(of: Lotto.self) { response in
                    switch response.result {
                    case .success(let lotto):
                        observer.onNext(lotto)
                        observer.onCompleted()
                    case .failure(let error):
                        print(error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
