//
//  LoginConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 16.09.2022.
//

import Foundation

@MainActor
protocol LoginConfigurator {
    func configure(loginViewController: LoginViewController)
}

class LoginConfiguratorImpl: LoginConfigurator {
    
    func configure(loginViewController: LoginViewController) {
        
        let remoteRepository = Session.shared.remoteRepositoryAPI
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        let authGateway = AuthGatewayImpl(profileGateway: profileGateway)
        let authUseCase = AuthUseCaseImpl(authGateway: authGateway)
        
        let loginRouter = LoginRouterImpl(viewController: loginViewController)
        let loginPresenter = LoginPresenterImpl(view: loginViewController, authUseCase: authUseCase, router: loginRouter)
        let loginRootView = LoginRootView()
        
        loginViewController.presenter = loginPresenter
        loginViewController.rootView = loginRootView
    }
}
