//
//  OrdersViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

import UIKit

class OrdersViewController: UIViewController {
    
    var configurator: OrdersConfigurator!
    var presenter: OrdersPresenter!
    var rootView: OrdersRootView!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(ordersViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
}

extension OrdersViewController: OrdersView {
    
    func display(title: String) {
        
    }
    
    func displayError(title: String, message: String?) {
        
    }
}
