//
//  CartViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

import UIKit

class CartViewController: UIViewController {
    
    var configurator: CartConfigurator!
    var presenter: CartPresenter!
    var rootView: CartRootView!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(cartViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await presenter.viewDidLoad() }
    }
    
}

extension CartViewController: CartView {
    
    func display(title: String) {
        self.title = title
    }
    
    func displayError(title: String, message: String?) {
        
    }
}
