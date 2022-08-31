//
//  ViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 11.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let authProvider = AuthProviderImpl()
    let profileLocalStorage = LocalStorageImpl()
    lazy var authGateway = AuthGatewayImpl(authProvider: authProvider, authLocalStorage: profileLocalStorage)
    lazy var authUseCases = AuthUseCasesImpl(authGateway: authGateway)
    
    let apiProduct = ApiProductImpl()
    let apiClient = ApiClientImpl()
    let imageCacher = ImageCacherImpl()
    lazy var productGateway = ProductGatewayImpl(apiProduct: apiProduct, apiClient: apiClient, imageCacher: imageCacher)
    lazy var productUseCases = ProductUseCasesImpl(productGateway: productGateway)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productUseCases.retrieveProducts { result in
            print(result)
        }
        
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
