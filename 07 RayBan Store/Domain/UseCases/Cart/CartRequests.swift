//
//  CartRequests.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 05.09.2022.
//

struct IsCartEmptyRequest {
    let user: User
}

struct IsProductInCartRequset {
    let user: User
    let productID: ProductID
}

struct GetCartItemsRequest {
    let user: User
}

struct AddCartItemRequest {
    let user: User
    let product: Product
    let amount: Int
}

struct DeleteCartItemRequest {
    let user: User
    let productID: Int
}

struct UpdateCartItemRequest {
    let user: User
    let productID: Int
    let amount: Int
}
