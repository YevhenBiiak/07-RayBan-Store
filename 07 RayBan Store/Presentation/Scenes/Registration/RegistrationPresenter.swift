//
//  RegistrationPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.02.2023.
//

@MainActor
protocol RegistrationRouter {
    func presentProducts()
    func dismiss(animated: Bool)
}

@MainActor
protocol RegistrationView: AnyObject {
    func display(firstNameFiledError: String)
    func display(lastNameFiledError: String)
    func display(emailFiledError: String)
    func display(passwordFiledError: String)
    func display(conformPasswordFiledError: String)
    func displayWarning(message: String)
    func displayAlert(title: String, message: String)
}

protocol RegistrationPresenter {
    func loginWithFacebookButtonTapped() async
    func createAccountButtonTapped(registreationParameters: RegistrationParameters) async
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
        await with(errorHandler) {
            let profile = try await authUseCase.executeLoginWithFacebookRequest()
            Session.shared.user = User(id: profile.id)
            await router.presentProducts()
        }
    }
    
    func createAccountButtonTapped(registreationParameters: RegistrationParameters) async {
        await with(errorHandler) {
            let registrationRequest = RegistrationRequest(registrationParameters: registreationParameters)
            let profile = try await authUseCase.execute(registrationRequest)
            Session.shared.user = User(id: profile.id)
            await router.presentProducts()
        }
    }
    
    func loginButtonTapped() async {
        await router.dismiss(animated: true)
    }
}

// MARK: - Private extension for helper methods

private extension RegistrationPresenterImpl {
    
    func errorHandler(_ error: Error) async {
        if let error = error as? AppError {
            switch error {
            case .networkError:          await view?.displayAlert(title: "Error", message: error.localizedDescription)
                
            case .firstNameValueIsEmpty: await view?.display(firstNameFiledError: error.localizedDescription)
                
            case .lastNameValueIsEmpty:  await view?.display(lastNameFiledError: error.localizedDescription)
                
            case .emailValueIsEmpty,
                 .emailFormatIsWrong,
                 .invalidEmail:          await view?.display(emailFiledError: error.localizedDescription)
                
            case .passwordValueIsEmpty,
                 .passwordLengthIsWrong,
                 .weakPassword:          await view?.display(passwordFiledError: error.localizedDescription)
                
            case .passwordsDoNotMatch:   await view?.display(conformPasswordFiledError: error.localizedDescription)
                
            case .emailAlreadyInUse,
                 .wrongPassword,
                 .facebookError,
                 .notAcceptedPolicy:     await view?.displayWarning(message: error.localizedDescription)
                
            case .unknown:
                fatalError(error.localizedDescription)
            default:
                print("irrelevant error for Registration:", error.localizedDescription)
            }
            return
        }
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
    }
}
