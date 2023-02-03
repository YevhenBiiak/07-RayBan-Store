//
//  RegistrationPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.02.2023.
//

@MainActor
protocol RegistrationRouter {
    func presentProducts(user: User)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

@MainActor
protocol RegistrationView: AnyObject {
    func displayError(_ error: Error)
}

protocol RegistrationPresenter {
    func loginWithFacebookButtonTapped() async
    func createAccountButtonTapped(firstName: String, lastName: String, email: String, password: String) async
    func loginButtonTapped() async
}

class RegistrationPresenterImpl {
    
    private weak var view: RegistrationView?
    private let router: RegistrationRouter
    private let authUseCase: AuthUseCase
    
    init(view: RegistrationView?, authUseCase: AuthUseCase, router: RegistrationRouter) {
        self.view = view
        self.authUseCase = authUseCase
        self.router = router
    }
}

extension RegistrationPresenterImpl: RegistrationPresenter {
    
    func loginWithFacebookButtonTapped() async {
        do {
            let user = try await authUseCase.executeLoginWithFacebookRequest()
            await router.presentProducts(user: user)
        } catch {
            await view?.displayError(error)
        }
    }
    
    func createAccountButtonTapped(firstName: String, lastName: String, email: String, password: String) async {
        do {
            let registrationRequest = RegistrationRequest(firstName: firstName, lastName: lastName, email: email, password: password)
            let user = try await authUseCase.execute(registrationRequest)
            await router.presentProducts(user: user)
        } catch {
            await view?.displayError(error)
        }
    }
    
    func loginButtonTapped() async {
        await router.dismiss(animated: true, completion: nil)
    }
}
