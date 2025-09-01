//
//  ViewController.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit
import RxSwift

protocol ViewModel { }
protocol ViewControllerDelegate: AnyObject {
    func dismiss()
}

final class EmptyViewControllerDelegate: ViewControllerDelegate {
    func dismiss() { }
}

class ViewController<ViewModel, Delegate: ViewControllerDelegate>: UIViewController {
    deinit {
        print(self, #function)
        delegate?.dismiss()
    }
    
    let disposeBag = DisposeBag()
    let viewModel: ViewModel
    var delegate: Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.background)
        navigationItem.backBarButtonItem?.title = ""
    }
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, deprecated)
    required init?(coder: NSCoder) {
        fatalError()
    }
}
