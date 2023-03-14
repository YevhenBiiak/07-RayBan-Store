//
//  PersonalDetailsConfigurator.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 13.03.2023.
//

@MainActor
protocol PersonalDetailsConfigurator {
    func configure(personalDetailsViewController: PersonalDetailsViewController)
}

class PersonalDetailsConfiguratorImpl: PersonalDetailsConfigurator {
    
    func configure(personalDetailsViewController: PersonalDetailsViewController) {
        
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        let profileUseCase = ProfileUseCaseImpl(profileGateway: profileGateway)
        
        let authGateway = AuthGatewayImpl(profileGateway: profileGateway)
        let authUseCase = AuthUseCaseImpl(authGateway: authGateway)
        
        let rootView = PersonalDetailsRootView()
        let router = PersonalDetailsRouterImpl(viewController: personalDetailsViewController)
        let presenter = PersonalDetailsPresenterImpl(view: personalDetailsViewController,
                                                     router: router,
                                                     authUseCase: authUseCase,
                                                     profileUseCase: profileUseCase)
        
        personalDetailsViewController.presenter = presenter
        personalDetailsViewController.rootView = rootView
    }
}
