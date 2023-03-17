//
//  EditEmailConfigurator.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 16.03.2023.
//

@MainActor
protocol EditEmailConfigurator {
    func configure(editEmailViewController: EditEmailViewController)
}

class EditEmailConfiguratorImpl: EditEmailConfigurator {
    
    private let successHandler: (() async -> Void)?
    
    init(successHandler: (() async -> Void)? = nil) {
        self.successHandler = successHandler
    }
    
    func configure(editEmailViewController: EditEmailViewController) {
        
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        
        let authGateway = AuthGatewayImpl(profileGateway: profileGateway)
        let authUseCase = AuthUseCaseImpl(authGateway: authGateway)
        
        let rootView = EditEmailRootView()
        let router = EditCredentialsRouterImpl(viewController: editEmailViewController)
        let presenter = EditEmailPresenterImpl(view: editEmailViewController,
                                               router: router,
                                               authUseCase: authUseCase,
                                               successHandler: successHandler)
        
        editEmailViewController.presenter = presenter
        editEmailViewController.rootView = rootView
    }
}
