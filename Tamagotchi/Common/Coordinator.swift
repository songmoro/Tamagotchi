//
//  Coordinator.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/28/25.
//

import UIKit

/*
 DI는 VM 생성 시 주입 -> 코디네이터에서도 담당하는 게 나을 수도 있다.
 tabBar 생성 -> 코디네이터가 window 객체를 보관하고 있으면, tabBar 만들고, ..., 할 필요 없이 start 메서드만으로 모든 동작 가능해진다.
 코디네이터:VC:VM 1:1:1 관계 -> D에서 B로 이동하고, B에서 C로 이동하거나 혹은 B에서 E로 이동할 상황에서 어떻게 할 건지? 그리고 이러한 상황에서 1:1 관계를 줄여나갈 수 있을 것 같다.
 delegate의 위치는 VC, VM 어느 위치에서 보관할 것인가?
 뷰 재사용 관련 -> 커스텀뷰에 뷰 모델을 주입하는 방법도 있다
 */







/*
 자식 코디네이터를 신경쓰는 게 복잡하고, 누수 혹은 누락을 감지하기 어려움
 
 1. 코디네이터 start시 담아주기
 2. 말단 코디네이터에서 한 번에 루트까지 팝할 때 중간 코디네이터 remove
 3. backBarItem으로 VC 팝 시
 */

/*
 위 문제는 루트 코디네이터에서 모든 작업을 해서 그런가?
 라는 이유로 계층에 따라 자식 코디네이터에서 코디네이터를 생성하고, 관리하려 했음
 하지만 위와 같은 방법을 시도하던 중 코디네이터를 재활용하는 게 중복 코드를 야기
 
 예. 루트와 설정 코디네이터 모두 다마고치 시작/변경 코디네이터를 생성할 수 있음
 */

/*
 위 문제를 해결하기 위해 생각한 것
 -> 코디네이터를 생성하는 담당에서 모든 코디네이터에 대한 생성 함수를 보유, 자식 코디네이터는 루트를 통해 생성하고 본인의 자식 코디네이터에 담기
 CoordinatorFactory { // 예시
    func makeChoice(_ coordinator:, _ childCoordinator: inout)
 }
 
 SettingsCoordinator {
    var delegate: AppCoordinator
    func showChoice() { delegate.makeChoice(self, child) }
 }
 */

/*
 코디네이터 패턴과는 다른 문제지만, 반복되는 고민
 처음에는 동일한 모습의 VC를 똑같은 VC를 하나 더 만들어 수정하여 사용
 이 VC을 재활용하고자 서로 다른 부분을 통해 로직을 분기해왔음
 예. mainVM: mainViewModel?
 if let mainVM { ... } else { ... }
 
 VC를 재사용하기 위해 고려하면 좋을 점에 대한 결론이 나지 않음
 
 현재 생각: VC를 재활용하지 않고, V 요소를 전부 컴포넌트로 변경 -> 각각 VC가 같은 V를 사용
 
 예.
 다마고치선택VC { let 모든다마고치컬렉션뷰 }
 다마고치변경VC { let 모든다마고치컬렉션뷰 }
 
 -> 전제조건: 뷰가 데이터에 대한 의존성을 가지지 않고, VC에서 주입(예. 유저디폴츠 값)
 */

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    func appendChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func new() {
        navigationController.viewControllers = []
        childCoordinators = []
    }
}
