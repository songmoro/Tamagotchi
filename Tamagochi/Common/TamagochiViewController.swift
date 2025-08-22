//
//  TamagochiViewController.swift
//  Tamagochi
//
//  Created by 송재훈 on 8/22/25.
//

import UIKit
import RxSwift

protocol ViewModel { }

class TamagochiViewController<ViewModel>: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: ViewModel
    
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
