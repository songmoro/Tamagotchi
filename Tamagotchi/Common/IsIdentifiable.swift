//
//  IsIdentifiable.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit

protocol IsIdentifiable {
    static var identifier: String { get }
}

extension IsIdentifiable {
    static var identifier: String {
        String(describing: Self.self)
    }
}

extension UITableView {
    func register<T: UITableViewCell & IsIdentifiable>(_ cellClass: T.Type) {
        self.register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell & IsIdentifiable>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withIdentifier: cellClass.identifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell & IsIdentifiable>(_ cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell & IsIdentifiable>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withReuseIdentifier: cellClass.identifier, for: indexPath) as! T
    }
}
