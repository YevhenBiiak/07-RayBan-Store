//
//  ViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 11.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var apiProfile = ApiProfileImpl()
    lazy var authProvider = AuthProviderImpl(apiProfile: apiProfile)
    lazy var profileLocalStorage = LocalStorageImpl()
    lazy var authGateway = AuthGatewayImpl(authProvider: authProvider, authLocalStorage: profileLocalStorage)
    
    lazy var apiProduct = ApiProductImpl()
    lazy var apiClient = ApiClientImpl()
    lazy var imageCacher = ImageCacherImpl()
    lazy var productGateway = ProductGatewayImpl(apiProduct: apiProduct, apiClient: apiClient, imageCacher: imageCacher)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //class MyViewController {
        //    lazy var apiProfile = ApiProfileImpl()
        //    lazy var authProvider = AuthProviderImpl(apiProfile: apiProfile)
        //    lazy var profileLocalStorage = LocalStorageImpl()
        //    lazy var authGateway = AuthGatewayImpl(authProvider: authProvider, authLocalStorage: profileLocalStorage)
        //
        //    func viewDidLoad() {
        //
        //        let useCase: UseCase = IsUserAuthenticatedUseCase(gateway: authGateway)
        //        useCase.execute { result in
        //            if let _ = try? result.get() {
        //
        //            }
        //        }
        //    }
        //}
        
//        useCase = LoginUseCase(gateway: authGateway)
        
//        print("isUserAuthenticated:", authUseCases.isUserAuthenticated)
//
//        authUseCases.loginWithFacebook { result in
//            switch result {
//            case.success(let flag):
//                print("loginWithFacebook flag:", flag)
//            case.failure(let error):
//                print("loginWithFacebook error:", error)
//            }
//        }
//
//        print("isUserAuthenticated:", authUseCases.isUserAuthenticated)
//        authUseCase.logout()
//        print("isUserAuthenticated:", authUseCases.isUserAuthenticated)
//
//        authUseCases.login(email: "fbname@mail.com", password: "123") { result in
//            switch result {
//            case.success(let flag):
//                print("login flag:", flag)
//            case.failure(let error):
//                print("login error:", error)
//            }
//        }
    }
    
}
