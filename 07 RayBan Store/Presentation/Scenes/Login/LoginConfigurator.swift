//
//  LoginConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 16.09.2022.
//

import Foundation

protocol LoginConfigurator {
    func configure(loginViewController: LoginViewController)
}

class LoginConfiguratorImpl: LoginConfigurator {
    
    func configure(loginViewController: LoginViewController) {
        
        let authProvider = AuthProviderImpl()
        let remoteRepository = RemoteRepositoryImpl()
        let profileGateway = ProfileGatewayImpl(remoteRepository: remoteRepository)
        let authGateway = AuthGatewayImpl(authProvider: authProvider, profileGateway: profileGateway)
        let loginUseCase = LoginUseCaseImpl(authGateway: authGateway)
        
        let loginRouter = LoginRouterImpl(loginViewController: loginViewController)
        let loginPresenter = LoginPresenterImpl(loginView: loginViewController, loginUseCase: loginUseCase, loginRouter: loginRouter)
        let loginRootView = LoginRootView()
        
        loginViewController.presenter = loginPresenter
        loginViewController.rootView = loginRootView
    }
}
