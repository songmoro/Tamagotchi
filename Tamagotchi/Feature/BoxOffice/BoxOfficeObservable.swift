//
//  BoxOfficeObservable.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/25/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class BoxOfficeObservable {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter
    }()
    
    private init() { }
    static func movie(_ date: String) -> Observable<BoxOfficeResponse> {
        return Observable.create { observer in
            guard dateFormatter.date(from: date) != nil else {
                return Disposables.create()
            }
            
            let url = URL(string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json")!
            let parameters = BoxOfficeParameters(key: Secret.boxOfficeApiKey, targetDt: date)
            
            AF.request(url, method: .get, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: BoxOfficeResponse.self) { response in
                    switch response.result {
                    case .success(let boxOfficeResponse):
                        observer.onNext(boxOfficeResponse)
                        observer.onCompleted()
                    default:
                        break
                    }
                }
            
            return Disposables.create()
        }
    }
}
