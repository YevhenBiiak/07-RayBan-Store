//
//  PersonalDetailsPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 13.03.2023.
//

@MainActor
protocol PersonalDetailsRouter {
    func presentLoginScene()
}

@MainActor
protocol PersonalDetailsView: AnyObject {
    func display(title: String)
    func display(viewModel: PersonalDetailsViewModel)
    func displayError(title: String, message: String?)
}

protocol PersonalDetailsPresenter {
    func viewDidLoad() async
    func logoutButtonTapped() async
}

class PersonalDetailsPresenterImpl {
    
    private weak var view: PersonalDetailsView?
    private let router: PersonalDetailsRouter
    private let authUseCase: AuthUseCase
    private let profileUseCase: ProfileUseCase
    
    init(view: PersonalDetailsView? = nil, router: PersonalDetailsRouter, authUseCase: AuthUseCase, profileUseCase: ProfileUseCase) {
        self.view = view
        self.router = router
        self.authUseCase = authUseCase
        self.profileUseCase = profileUseCase
    }
}

extension PersonalDetailsPresenterImpl: PersonalDetailsPresenter {
    
    func viewDidLoad() async {
        await with(errorHandler) {
            let request = GetProfileRequest(user: Session.shared.user)
            let profile = try await profileUseCase.execute(request)
            await view?.display(title: "\(profile.firstName ?? "") \(profile.lastName ?? "")")
            let viewModel = createPersonalDetailsModel(with: profile)
            await view?.display(viewModel: viewModel)
        }
    }
    
    func logoutButtonTapped() async {
        await with(errorHandler) {
            try authUseCase.executeLogoutRequest()
            await router.presentLoginScene()
        }
    }
}

// MARK: - Private extension

private extension PersonalDetailsPresenterImpl {
    
    func createPersonalDetailsModel(with profile: Profile) -> PersonalDetailsModel {
        .init(
            firstName: profile.firstName ?? "",
            lastName: profile.lastName ?? "",
            phoneNumber: profile.phone ?? "",
            shippingAddress: profile.address ?? "",
            emailAddress: profile.email
        )
    }
    
    func errorHandler(_ error: Error) async {
        await view?.displayError(title: "Error", message: error.localizedDescription)
    }
}
