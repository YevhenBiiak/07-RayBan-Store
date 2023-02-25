//
//  Favorite.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

struct FavoritList {
    
    var items: [FavoriteItem]
    
    mutating func add(product: Product) {
        let item = FavoriteItem(product: product)
        if !contains(product) {
            items.append(item)
        }
    }
    
    mutating func delete(modelID: ModelID) {
        items.removeAll { $0.product.modelID == modelID }
    }
    
    func contains(_ product: Product) -> Bool {
        items.contains {
            $0.product.modelID == product.modelID
        }
    }
}

struct FavoriteItem {
    let product: Product
}
