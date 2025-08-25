//
//  BoxOfiiceViewController.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/25/25.
//

import UIKit
import Alamofire
import SnapKit
import RxSwift
import RxCocoa

struct BoxOfficeResponse: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Decodable {
    let movieNm: String
}

struct BoxOfficeParameters: Encodable {
    let key, targetDt: String
}

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

final class BoxOfiiceViewController: ViewController<BoxOfiiceViewModel> {
    private let searchBar = UISearchBar()
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(
            .init(
                text: searchBar.rx.text.orEmpty.asObservable(),
                click: searchBar.rx.searchButtonClicked.asObservable()
            )
        )
        
        output.movies
            .drive(label.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        [searchBar, label].forEach(view.addSubview)
        
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide).inset(12)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
        
        searchBar.searchBarStyle = .prominent
        label.text = "영화 제목1\n영화 제목2"
        label.numberOfLines = 0
    }
}
