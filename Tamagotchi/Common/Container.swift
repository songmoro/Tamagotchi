//
//  Container.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/27/25.
//

import Foundation
import RxSwift
import RxCocoa

final class Container {
    private let disposeBag = DisposeBag()
    static let shared = Container()
    
    private(set) var account: BehaviorRelay<Account?>
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: "account"), let account = try? PropertyListDecoder().decode(Account.self, from: data) {
            self.account = BehaviorRelay(value: account)
        }
        else {
            self.account = BehaviorRelay(value: nil)
        }
        
        self.account
            .bind {
                let data = try? PropertyListEncoder().encode($0)
                UserDefaults.standard.set(data, forKey: "account")
            }
            .disposed(by: disposeBag)
    }
}
