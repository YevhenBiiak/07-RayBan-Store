//
//  LoginViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 06.09.2022.
//

import UIKit

class LoginViewController: UIViewController, LoginView {
    
    var configurator: LoginConfigurator!
    var presenter: LoginPresenter!
    
    var rootView: LoginRootView!
        
    // MARK: - Life Cycle and overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(loginViewController: self)

    }

    func displayError(_ error: Error) {
        
    }
    
}
