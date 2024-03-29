//
//  CheckoutRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.03.2023.
//

import UIKit

class CheckoutRouterImpl: Routable, CheckoutRouter {
    
    weak var viewController: CheckoutViewController!
    
    required init(viewController: CheckoutViewController) {
        self.viewController = viewController
    }
    
    func presentThankYouForOrder() {
        let thankYouViewController = ThankYouViewController(onDismiss: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        navigationController?.present(thankYouViewController, animated: true)
    }
}
