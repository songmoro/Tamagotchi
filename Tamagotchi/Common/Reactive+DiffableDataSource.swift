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
    func sectionSelected<SectionIdentifierType, ItemIdentifierType>(_ dataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>) -> ControlEvent<SectionIdentifierType> where SectionIdentifierType: Hashable, SectionIdentifierType: Sendable, ItemIdentifierType: Hashable, ItemIdentifierType: Sendable {
        let source: Observable<SectionIdentifierType> = self.itemSelected.flatMap { [weak view = self.base as UITableView] indexPath -> Observable<SectionIdentifierType> in
            guard view != nil else {
                return Observable.empty()
            }
            guard let section = dataSource.sectionIdentifier(for: indexPath.section) else {
                return Observable.empty()
            }
            
            return Observable.just(section)
        }
        
        return ControlEvent(events: source)
    }
    
    func itemSelected<SectionIdentifierType, ItemIdentifierType>(_ dataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>) -> ControlEvent<ItemIdentifierType> where SectionIdentifierType: Hashable, SectionIdentifierType: Sendable, ItemIdentifierType: Hashable, ItemIdentifierType: Sendable {
        let source: Observable<ItemIdentifierType> = self.itemSelected.flatMap { [weak view = self.base as UITableView] indexPath -> Observable<ItemIdentifierType> in
            guard view != nil else {
                return Observable.empty()
            }
            guard let item = dataSource.itemIdentifier(for: indexPath) else {
                return Observable.empty()
            }
            
            return Observable.just(item)
        }
        
        return ControlEvent(events: source)
    }
}
