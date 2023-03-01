//
//  LoginPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 05.09.2022.
//

@MainActor
protocol LoginRouter {
    func presentProducts()
    func presentRegistrationScene()
    func presentForgotPasswordScene()
    func dismiss(animated: Bool)
}

@MainActor
protocol LoginView: AnyObject {
    func display(emailFiledError: String)
    func display(passwordFiledError: String)
    func displayWarning(message: String)
    func displayAlert(title: String, message: String)
}

protocol LoginPresenter {
    func loginButtonTapped(email: String, password: String) async
    func loginWithFacebookButtonTapped() async
    func createAccountButtonTapped() async
    func forgotPasswordButtonTapped() async
}

class LoginPresenterImpl {
    
    private weak var view: LoginView?
    private let router: LoginRouter
    private let authUseCase: AuthUseCase
    
    init(view: LoginView?, authUseCase: AuthUseCase, router: LoginRouter) {
        self.view = view
        self.authUseCase = authUseCase
        self.router = router
    }
}

extension LoginPresenterImpl: LoginPresenter {
    
    func loginButtonTapped(email: String, password: String) async {
        await with(errorHandler) {
            let loginRequest = LoginRequest(email: email, password: password)
            let profile = try await authUseCase.execute(loginRequest)
            Session.shared.user = User(id: profile.id)
            await router.presentProducts()
        }
    }
    
    func loginWithFacebookButtonTapped() async {
        await with(errorHandler) {
            let profile = try await authUseCase.executeLoginWithFacebookRequest()
            Session.shared.user = User(id: profile.id)
            await router.presentProducts()
        }
    }
    
    func createAccountButtonTapped() async {
        await router.presentRegistrationScene()
    }
    
    func forgotPasswordButtonTapped() async {
        await router.presentForgotPasswordScene()
    }
}

// MARK: - Private extension for helper methods

private extension LoginPresenterImpl {
    
    func errorHandler(_ error: Error) async {
        if let error = error as? AppError {
            switch error {
            case .networkError:          await view?.displayAlert(title: "Error", message: error.localizedDescription)
                
            case .emailValueIsEmpty,
                 .emailFormatIsWrong,
                 .invalidEmail:          await view?.display(emailFiledError: error.localizedDescription)

            case .passwordValueIsEmpty,
                 .passwordLengthIsWrong,
                 .weakPassword:         await view?.display(passwordFiledError: error.localizedDescription)

            case .userNotFound,
                 .wrongPassword,
                 .invalidRecipientEmail,
                 .facebookError:        await view?.displayWarning(message: error.localizedDescription)
                
            case .permissionsDenied:    await view?.displayAlert(title: "Error", message: error.localizedDescription)
            
            case .unknown:
                fatalError(error.localizedDescription)
            default:
                print("Irrelevant error for Login:", error.localizedDescription)
            }
            return
        }
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
    }
}
