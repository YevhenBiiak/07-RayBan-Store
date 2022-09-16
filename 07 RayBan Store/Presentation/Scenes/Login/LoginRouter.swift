//
//  LoginRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 16.09.2022.
//

import Foundation

class LoginRouterImpl: LoginRouter {
    
    private weak var loginViewController: LoginViewController?
    
    init(loginViewController: LoginViewController) {
        self.loginViewController = loginViewController
    }
    
    func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        loginViewController?.dismiss(animated: flag, completion: completion)
    }
}
