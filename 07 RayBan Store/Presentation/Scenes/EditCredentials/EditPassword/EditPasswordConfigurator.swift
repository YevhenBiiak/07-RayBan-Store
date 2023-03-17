//
//  EditPasswordConfigurator.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 17.03.2023.
//

@MainActor
protocol EditPasswordConfigurator {
    func configure(editPasswordViewController: EditPasswordViewController)
}

class EditPasswordConfiguratorImpl: EditPasswordConfigurator {
    
    func configure(editPasswordViewController: EditPasswordViewController) {
        
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        
        let authGateway = AuthGatewayImpl(profileGateway: profileGateway)
        let authUseCase = AuthUseCaseImpl(authGateway: authGateway)
        
        let rootView = EditPasswordRootView()
        let router = EditCredentialsRouterImpl(viewController: editPasswordViewController)
        let presenter = EditPasswordPresenterImpl(view: editPasswordViewController,
                                                  router: router,
                                                  authUseCase: authUseCase)
        
        editPasswordViewController.presenter = presenter
        editPasswordViewController.rootView = rootView
    }
}
