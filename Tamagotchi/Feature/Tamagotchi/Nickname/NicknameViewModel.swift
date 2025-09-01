//
//  NicknameViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: ViewModel {
    deinit {
        print(self, #function)
    }
    
    enum Action {
        case `init`
        case text(String)
    }
    enum Mutation {
        case placeholder
        case modify(String)
        case save
    }
    struct State {
        var account: Account?
        var dismiss: Void? = nil
    }
    
    let action: PublishSubject<Action>
    var state: Driver<State> {
        stateRelay.asDriver(onErrorJustReturn: .init())
    }
    
    private let disposeBag: DisposeBag
    private let stateRelay: BehaviorSubject<State>
    
    init(initialState: State) {
        self.disposeBag = DisposeBag()
        self.action = PublishSubject<Action>()
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
            return .just(.placeholder)
        case .text(let text):
            return .concat([
                .just(.modify(text)),
                .just(.save)
            ])
        }
    }
    
    private func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .placeholder:
            newState.account = Container.shared.account.value
        case .modify(let text):
            guard 2...6 ~= text.count else {
                return state
            }
            guard var newAccount = newState.account else {
                return state
            }
            
            newAccount.nickname = text
            newState.account = newAccount
        case .save:
            Container.shared.account.accept(state.account)
            newState.dismiss = ()
        }
        
        return newState
    }
}
