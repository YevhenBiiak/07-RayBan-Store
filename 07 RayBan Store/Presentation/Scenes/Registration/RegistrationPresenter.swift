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
    func display(error: RegistrationError)
}

protocol RegistrationPresenter {
    func loginWithFacebookButtonTapped() async
    func createAccountButtonTapped(registreationParameters: RegistrationParameters, conformPassword: String, acceptedPolicy: Bool) async
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
        await withHandler {
            let user = try await authUseCase.executeLoginWithFacebookRequest()
            await router.presentProducts(user: user)
        }
    }
    
    func createAccountButtonTapped(
        registreationParameters: RegistrationParameters,
        conformPassword: String,
        acceptedPolicy: Bool
    ) async {
        await withHandler {
            let registrationRequest = RegistrationRequest(
                registrationParameters: registreationParameters,
                conformPassword: conformPassword,
                acceptedPolicy: acceptedPolicy)
            let user = try await authUseCase.execute(registrationRequest)
            await router.presentProducts(user: user)
        }
    }
    
    func loginButtonTapped() async {
        await router.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private extension for helper methods

private extension RegistrationPresenterImpl {
    
    func withHandler(_ code: () async throws -> Void) async {
        do    { return try await code() }
        catch { await handle(error) }
    }
    
    func handle(_ error: Error) async {
        if let error = error as? AuthUseCaseError {
            switch error {
            // first name
            case .firstNameValueIsEmpty:
                await view?.display(error: .firstNameError(error.localizedDescription))
            // last name
            case .lastNameValueIsEmpty:
                await view?.display(error: .lastNameError(error.localizedDescription))
            // email errors
            case .emailValueIsEmpty, .emailFormatIsWrong, .invalidEmail:
                await view?.display(error: .emailError(error.localizedDescription))
            // password errors
            case .passwordValueIsEmpty, .passwordLengthIsWrong, .weakPassword:
                await view?.display(error: .passwordError(error.localizedDescription))
            // login errors
            case .emailAlreadyInUse:
                await view?.display(error: .emailAlreadyInUse(error.localizedDescription))
            // facebook errors
            case .facebookError(let error):
                await view?.display(error: .facebookError(error.localizedDescription))
            // additionally
            case .passwordsDoNotMatch:
                await view?.display(error: .passwordsDoNotMatch(error.localizedDescription))
            case .notAcceptedPolicy:
                await view?.display(error: .notAcceptedPolicy(error.localizedDescription))
            // irrelevant errors in this case
            case .fbLoginWasCancelled, .wrongPassword, .userNotFound:
                break
            }
            return
        }
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
    }
}

enum RegistrationError {
    case firstNameError(String)
    case lastNameError(String)
    case emailError(String)
    case passwordError(String)
    case emailAlreadyInUse(String)
    case passwordsDoNotMatch(String)
    case notAcceptedPolicy(String)
    case facebookError(String)
    
    var title: String { "Error" }
    
    var message: String {
        switch self {
        case .firstNameError(let message):      return message
        case .lastNameError(let message):       return message
        case .emailError(let message):          return message
        case .passwordError(let message):       return message
        case .emailAlreadyInUse(let message):   return message
        case .passwordsDoNotMatch(let message): return message
        case .notAcceptedPolicy(let message):   return message
        case .facebookError(let message):       return message
        }
    }
}
