//
//  RegistrationConfigurator.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.02.2023.
//

@MainActor
protocol RegistrationConfigurator {
    func configure(registrationViewController: RegistrationViewController)
}

class RegistrationConfiguratorImpl: RegistrationConfigurator {
    
    func configure(registrationViewController: RegistrationViewController) {
        
        let remoteRepository = RemoteRepositoryImpl()
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        let authGateway = AuthGatewayImpl(profileGateway: profileGateway)
        let authUseCase = AuthUseCaseImpl(authGateway: authGateway)
        
        let registrationRouter = RegistrationRouterImpl(viewController: registrationViewController)
        let registrationPresenter = RegistrationPresenterImpl(view: registrationViewController, authUseCase: authUseCase, router: registrationRouter)
        let registrationRootView = RegistrationRootView()
        
        registrationViewController.presenter = registrationPresenter
        registrationViewController.rootView = registrationRootView
    }
}
