//
//  EditCredentialConfigurator.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 16.03.2023.
//

@MainActor
protocol EditCredentialsConfigurator {
    func configure(editCredentialsViewController: EditCredentialsViewController)
}

class EditCredentialsConfiguratorImpl: EditCredentialsConfigurator {
    
    private let changeType: CredentialType
    private let successCompletion: (() async -> Void)?
    
    init(changeType: CredentialType, successCompletion: (() async -> Void)? = nil) {
        self.changeType = changeType
        self.successCompletion = successCompletion
    }
    
    func configure(editCredentialsViewController: EditCredentialsViewController) {
        
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        
        let authGateway = AuthGatewayImpl(profileGateway: profileGateway)
        let authUseCase = AuthUseCaseImpl(authGateway: authGateway)
        
        let rootView = EditCredentialsRootView()
        let router = EditCredentialsRouterImpl(viewController: editCredentialsViewController)
        let presenter = EditCredentialsPresenterImpl(view: editCredentialsViewController,
                                                     router: router,
                                                     authUseCase: authUseCase,
                                                     changeType: changeType,
                                                     successCompletion: successCompletion)
        
        editCredentialsViewController.presenter = presenter
        editCredentialsViewController.rootView = rootView
    }
}
