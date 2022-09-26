//
//  MenuListRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import Foundation

class MenuListRouterImpl: MenuListRouter {
    private weak var menuListViewController: MenuListViewController?
    
    init(menuListViewController: MenuListViewController?) {
        self.menuListViewController = menuListViewController
    }
}
