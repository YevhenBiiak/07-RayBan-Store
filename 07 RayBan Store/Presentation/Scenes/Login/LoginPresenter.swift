//
//  LoginPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 05.09.2022.
//

import Foundation

protocol LoginRouter {
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

protocol LoginView: AnyObject {
    func displayError(_ error: Error)
}

protocol LoginPresenter {
    func viewDidLoad()
    func loginButtonTapped(email: String, password: String)
}

class LoginPresenterImpl: LoginPresenter {
    
    private weak var loginView: LoginView?
    private var loginRouter: LoginRouter
    private let loginUseCase: LoginUseCase
    
    init(loginView: LoginView?, loginUseCase: LoginUseCase, loginRouter: LoginRouter) {
        self.loginView = loginView
        self.loginUseCase = loginUseCase
        self.loginRouter = loginRouter
    }
    
    func viewDidLoad() {
        
    }
    
    func loginButtonTapped(email: String, password: String) {
        let loginRequest = LoginRequest(email: email, password: password)
        loginUseCase.execute(loginRequest) { [weak self] result in
            switch result {
            case .success:
                self?.loginRouter.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self?.loginView?.displayError(error)
            }
        }
    }
}

protocol LoginConfigurator {
    func configure(loginViewController: LoginViewController)
}

class LoginConfiguratorImpl: LoginConfigurator {
    
    func configure(loginViewController: LoginViewController) {
        
    }
    
}
