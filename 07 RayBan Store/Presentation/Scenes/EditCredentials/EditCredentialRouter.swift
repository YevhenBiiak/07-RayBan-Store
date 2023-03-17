//
//  EditCredentialRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 16.03.2023.
//

import UIKit

@MainActor
protocol EditCredentialsRouter {
    func dismiss(animated: Bool)
}

class EditCredentialsRouterImpl: Routable, EditCredentialsRouter {
    
    weak var viewController: UIViewController!
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func dismiss(animated: Bool) {
        viewController.dismiss(animated: animated)
    }
}
