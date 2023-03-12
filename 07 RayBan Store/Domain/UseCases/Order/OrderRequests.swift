//
//  OrderRequests.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.03.2023.
//

struct OrdersRequest {
    let user: User
}

struct DeleteOrderRequest {
    let user: User
    let orderID: OrderID
}
