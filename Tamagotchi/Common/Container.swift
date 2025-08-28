//
//  Container.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/27/25.
//

import Foundation
import RxSwift

final class Container {
    static let shared = Container()
    
    private init() { }
    
    private(set) var account: Account? = {
        guard let data = UserDefaults.standard.data(forKey: "account"),
        let character = try? PropertyListDecoder().decode(Account.self, from: data) else {
            return nil
        }
        
        return character
    }()
    
    func update(_ account: Account?) {
        let data = try? PropertyListEncoder().encode(account)
        UserDefaults.standard.set(data, forKey: "account")
        self.account = account
    }
}
