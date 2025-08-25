//
//  LotteryViewController.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/25/25.
//

import UIKit
import Alamofire
import SnapKit
import RxSwift
import RxCocoa

struct Lotto: Decodable {
    let drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6, bnusNo: Int
}

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
            .flatMap(MyObservable.lottery(no:))
            .map { [$0.drwtNo1, $0.drwtNo2, $0.drwtNo3, $0.drwtNo4, $0.drwtNo5, $0.drwtNo6, $0.bnusNo] }
            .map { $0.map(\.description).joined(separator: ", ") }
            .bind(to: lotto)
            .disposed(by: disposeBag)
        
        return .init(
            lotto: lotto.asDriver(onErrorJustReturn: "")
        )
    }
}

final class MyObservable {
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

final class LotteryViewController: ViewController<LotteryViewModel> {
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
        
        output.lotto
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
            $0.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide)
        }
        
        searchBar.searchBarStyle = .prominent
        label.text = "0, 0, 0, 0, 0, 0, 0"
    }
}
