//
//  EditCredentialRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 16.03.2023.
//

import UIKit

class EditCredentialsRouterImpl: Routable, EditCredentialsRouter {
    
    weak var viewController: EditCredentialsViewController!
    
    required init(viewController: EditCredentialsViewController) {
        self.viewController = viewController
    }
    
    func dismiss(animated: Bool) {
        viewController.dismiss(animated: animated)
    }
}
