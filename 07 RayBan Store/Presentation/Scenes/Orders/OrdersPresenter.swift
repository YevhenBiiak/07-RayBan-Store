//
//  OrdersPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

@MainActor
protocol OrdersRouter {
    func presentOrders()
}

@MainActor
protocol OrdersView: AnyObject {
    func display(title: String)
    func displayError(title: String, message: String?)
}

protocol OrdersPresenter {
    func viewDidLoad()
}

class OrdersPresenterImpl {
    
    private weak var view: OrdersView?
    private let router: OrdersRouter
    
    init(view: OrdersView?, router: OrdersRouter) {
        self.view = view
        self.router = router
    }
}

extension OrdersPresenterImpl: OrdersPresenter {
    
    func viewDidLoad() {
        
    }
}

// MARK: - Private extension

private extension OrdersPresenterImpl {
    
    func helper()  {
        
    }
}
