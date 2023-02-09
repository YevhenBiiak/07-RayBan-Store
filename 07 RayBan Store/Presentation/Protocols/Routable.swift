//
//  Routable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.02.2023.
//

import UIKit

@MainActor
protocol Routable {
    associatedtype ViewController: UIViewController
    var viewController: ViewController! { get }
    var navigationController: UINavigationController? { get }
    init(viewController: ViewController)
    func dismiss(animated: Bool)
}

extension Routable {
    var navigationController: UINavigationController? {
        viewController.navigationController
    }
    func dismiss(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
}
