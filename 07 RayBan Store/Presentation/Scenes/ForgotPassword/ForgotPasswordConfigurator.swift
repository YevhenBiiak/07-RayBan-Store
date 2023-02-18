//
//  ForgotPasswordConfigurator.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.02.2023.
//

@MainActor
protocol ForgotPasswordConfigurator {
    func configure(forgotPasswordViewController: ForgotPasswordViewController)
}

class ForgotPasswordConfiguratorImpl: ForgotPasswordConfigurator {
    
    func configure(forgotPasswordViewController: ForgotPasswordViewController) {
        
        let remoteRepository = RemoteRepositoryImpl()
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        let authGateway = AuthGatewayImpl(profileGateway: profileGateway)
        let authUseCase = AuthUseCaseImpl(authGateway: authGateway)
        
        let forgotPasswordRouter = ForgotPasswordRouterImpl(viewController: forgotPasswordViewController)
        let forgotPasswordPresenter = ForgotPasswordPresenterImpl(view: forgotPasswordViewController, authUseCase: authUseCase, router: forgotPasswordRouter)
        let forgotPasswordRootView = ForgotPasswordRootView()
        
        forgotPasswordViewController.presenter = forgotPasswordPresenter
        forgotPasswordViewController.rootView = forgotPasswordRootView
    }
}
