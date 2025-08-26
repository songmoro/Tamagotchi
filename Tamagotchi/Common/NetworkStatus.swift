//
//  NetworkStatus.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/26/25.
//

import Alamofire
import RxSwift

enum NetworkStatusType {
    case disconnect
    case connect
    case unknown
}

final class NetworkStatus {
    static let shared = NetworkStatus()
    private init() {
        observeReachability()
    }
    
    private let statusSubject = BehaviorSubject<NetworkStatusType>(value: .connect)
    
    var statusObservable: Observable<NetworkStatusType> {
        statusSubject
    }
    
    private func observeReachability() {
        NetworkReachabilityManager()?.startListening { [weak statusSubject] status in
            switch status {
            case .notReachable:
                statusSubject?.onNext(.disconnect)
            case .reachable:
                statusSubject?.onNext(.connect)
            case .unknown :
                statusSubject?.onNext(.unknown)
            }
        }
    }
}
