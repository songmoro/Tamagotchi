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
    
    // TODO: 기본 상태에 따른 뷰 업데이트 방법 고민해보기
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
    
    deinit {
        print(self, #function)
    }
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let row: Observable<Int>
    }
    struct Output {
        let settings: Driver<Settings>
        let nickname: Driver<Void>
        let change: Driver<Tamagotchi>
        let reset: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let rowAction = PublishRelay<Int>()
        let settings = BehaviorRelay<Settings>(value: .nickname(""))
        let account = Container.shared.account
        let nickname = PublishRelay<Void>()
        let change = PublishRelay<Tamagotchi>()
        let reset = PublishRelay<Void>()
        
        input.row
            .bind(to: rowAction)
            .disposed(by: disposeBag)
        
        account
            .compactMap(\.?.nickname)
            .map { nickname -> Settings in
                    .nickname(nickname)
            }
            .bind(to: settings)
            .disposed(by: disposeBag)
        
        rowAction
            .bind {
                if $0 == 0 {
                    nickname.accept(())
                }
                else if $0 == 1 {
                    guard let tamagotchi = account.value?.tamagotchi else { return }
                    change.accept(tamagotchi)
                }
                else if $0 == 2 {
                    reset.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        return .init(
            settings: settings.asDriver(onErrorJustReturn: .nickname("")),
            nickname: nickname.asDriver(onErrorJustReturn: ()),
            change: change.asDriver(onErrorJustReturn: .cactus),
            reset: reset.asDriver(onErrorJustReturn: ())
        )
    }
}
