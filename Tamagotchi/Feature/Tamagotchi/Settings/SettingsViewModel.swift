//
//  SettingsViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReactorProtocol {
    associatedtype Action
    associatedtype Mutation
    associatedtype State
    var action: PublishSubject<Action> { get set }
    var stateRelay: BehaviorSubject<State> { get set }
    var state: Driver<State> { get set }
    init(initialState: State)
    func mutate(action: Action) -> Observable<Mutation>
    func reduce(state: State, mutation: Mutation) -> State
}

final class SettingsViewModel {
    private let disposeBag = DisposeBag()
    
    deinit {
        print(self, #function)
    }
    
    enum Action {
        case `init`
        case section(SettingsViewController.Section)
    }
    
    enum Mutation {
        case settings
        case section(SettingsViewController.Section?)
    }
    
    struct State {
        var account: Account
        var settings: Settings
        var section: SettingsViewController.Section?
    }
    
    let action = PublishSubject<Action>()
    private let stateRelay: BehaviorSubject<State>
    var state: Driver<State> {
        stateRelay.asDriver(onErrorJustReturn: .init(account: .init(tamagotchi: .preparing), settings: .nickname("")))
    }
    
    init(initialState: State) {
        self.stateRelay = BehaviorSubject(value: initialState)
        
        action
            .flatMap { [weak self] action -> Observable<Mutation> in
                guard let self else { return .empty() }
                return self.mutate(action: action)
            }
            .withLatestFrom(stateRelay) { [weak self] mutation, currentState -> State? in
                guard let self else { return nil }
                return self.reduce(state: currentState, mutation: mutation)
            }
            .compactMap(\.self)
            .bind(to: stateRelay)
            .disposed(by: disposeBag)
        
        action.onNext(.`init`)
    }
    
    private func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .`init`:
            return .just(.settings)
            
        case .section(let settings):
            return .concat([
                .just(.section(settings)),
                .just(.section(nil))
            ])
        }
    }
    
    private func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .settings:
            let nickname = state.account.nickname
            let settings = Settings.nickname(nickname)
            
            newState.settings = settings
        case .section(let transitionType):
            newState.section = transitionType
        }
        
        return newState
    }
}
