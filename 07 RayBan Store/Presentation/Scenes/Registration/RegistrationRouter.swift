//
//  RegistrationRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.02.2023.
//

import UIKit

class RegistrationRouterImpl: RegistrationRouter {
    
    private weak var viewController: RegistrationViewController!
    
    private var navigationController: UINavigationController? {
        viewController.navigationController
    }
    
    init(viewController: RegistrationViewController) {
        self.viewController = viewController
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationController?.popViewController(animated: animated)
    }

    func presentProducts(user: User) {
        // create Products viewcontroller
    }
}
