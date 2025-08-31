//
//  SettingsViewModel.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsViewModel {
    private let disposeBag = DisposeBag()
    
    deinit {
        print(self, #function)
    }
    
    enum Action {
        case `init`
        case tap(row: Int)
    }
    
    enum Mutation {
        case settings
        case transition(to: SettingsViewController.Section?)
        case showFailedAlert(message: String)
    }
    
    struct State {
        var account: Account
        var settings: Settings
        var transition: SettingsViewController.Section?
    }
    
    let action = PublishSubject<Action>()
    private let stateRelay: BehaviorSubject<State>
    
    var state: Observable<State> {
        stateRelay.asObservable()
    }
    
    init(initialState: State) {
        self.stateRelay = BehaviorSubject(value: initialState)
        
        action
            .flatMap { [weak self] action -> Observable<Mutation> in
                guard let self else { return .empty() }
                return self.mutate(action: action)
            }
            .withLatestFrom(stateRelay) { mutation, currentState in
                self.reduce(state: currentState, mutation: mutation)
            }
            .subscribe(onNext: self.stateRelay.onNext(_:), onDisposed: {
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        action.onNext(.`init`)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .`init`:
            return .just(.settings)
            
        case .tap(let row):
            guard let section = SettingsViewController.Section(rawValue: row) else {
                return .just(.showFailedAlert(message: "화면을 전환하는 데 실패했습니다."))
            }
            return .just(.transition(to: section))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .settings:
            let nickname = state.account.nickname
            let settings = Settings.nickname(nickname)
            
            newState.settings = settings
        case .transition(let transitionType):
            newState.transition = transitionType
        case .showFailedAlert(let message):
            print("\(message)")
        }
        
        return newState
    }
}
