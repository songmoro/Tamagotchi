//
//  NetworkMonitor.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/26/25.
//

import Foundation
import Network
import RxSwift

enum NetworkStatusType {
    case disconnect
    case connect
    case unknown
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let status = BehaviorSubject<NetworkStatusType>(value: .connect)
    
    var isConnected: Bool {
        try! status.value() == .connect
    }
    
    private init() {
        monitor = NWPathMonitor()
        start()
    }
    
    func start() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak status] path in
            print("1", path, Date())
            status?.onNext((path.status == .satisfied) ? .connect : .disconnect)
        }
    }
    
    func stop() {
        monitor.cancel()
    }
}
