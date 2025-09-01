//
//  Reactive+DiffableDataSource.swift
//  Tamagotchi
//
//  Created by 송재훈 on 9/1/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    func sectionSelected<SectionIdentifierType, ItemIdentifierType>(_ dataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>) -> ControlEvent<SectionIdentifierType> where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
        let source: Observable<SectionIdentifierType> = self.itemSelected
            .compactMap { [weak dataSource] indexPath in
                dataSource?.sectionIdentifier(for: indexPath.section)
            }
        
        return ControlEvent(events: source)
    }
    
    func itemSelected<SectionIdentifierType, ItemIdentifierType>(_ dataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>) -> ControlEvent<ItemIdentifierType> where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
        let source: Observable<ItemIdentifierType> = self.itemSelected
            .compactMap { [weak dataSource] indexPath in
                dataSource?.itemIdentifier(for: indexPath)
            }
        
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UICollectionView {
    func sectionSelected<SectionIdentifierType, ItemIdentifierType>(_ dataSource: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>) -> ControlEvent<SectionIdentifierType> where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
        let source: Observable<SectionIdentifierType> = self.itemSelected
            .compactMap { [weak dataSource] indexPath in
                dataSource?.sectionIdentifier(for: indexPath.section)
            }
        
        return ControlEvent(events: source)
    }
    
    func itemSelected<SectionIdentifierType, ItemIdentifierType>(_ dataSource: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>) -> ControlEvent<ItemIdentifierType> where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
        let source: Observable<ItemIdentifierType> = self.itemSelected
            .compactMap { [weak dataSource] indexPath in
                dataSource?.itemIdentifier(for: indexPath)
            }
        
        return ControlEvent(events: source)
    }
}
