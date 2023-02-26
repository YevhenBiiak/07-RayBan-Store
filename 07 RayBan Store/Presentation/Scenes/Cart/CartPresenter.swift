//
//  CartPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

@MainActor
protocol CartRouter {
    func presentCart()
}

@MainActor
protocol CartView: AnyObject {
    func display(title: String)
    func displayError(title: String, message: String?)
}

protocol CartPresenter {
    func viewDidLoad() async
}

class CartPresenterImpl {
    
    private weak var view: CartView?
    private let router: CartRouter
    
    init(view: CartView?, router: CartRouter) {
        self.view = view
        self.router = router
    }
}

extension CartPresenterImpl: CartPresenter {
    
    func viewDidLoad() async {
        await view?.display(title: "SHOPPING BAG")
    }
}

// MARK: - Private extension

private extension CartPresenterImpl {
    
    func helper()  {
        
    }
}
