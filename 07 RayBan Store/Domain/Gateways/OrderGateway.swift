//
//  OrderGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.09.2022.
//

import Foundation

protocol OrderGateway {
    func fetchShippingMethods() async throws -> [ShippingMethod]
}
