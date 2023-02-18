//
//  ProductVM.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 22.09.2022.
//

import UIKit

struct ProductsSection: Sectionable {
    var header: String
    var items: [IndexPath: any Itemable]
}
struct ProductItem: Itemable {
    var viewModel: ProductCellViewModel?
}

struct ProductCellViewModel {
    let productID: Int
    let isNew: Bool
    let isInCart: Bool
    let name: String
    let price: String
    let colors: String
    let imageData: Data
    let indexPath: IndexPath
    let addButtonTapped: (ProductCellViewModel) async -> Void
    let cartButtonTapped: () async -> Void
}

struct ProductVM {
    let id: String
    let nameLabel: String
    let type: String
    let family: String
    let gender: String
    let size: String
    let geofit: String
    let colorsLabel: String
    let variations: [ProductVariantVM]
    let details: String
    var images: [UIImage]
}

struct ProductVariantVM {
    let priceLabel: String
    let frameColor: String
    let lenseColor: String
    let priceInCents: Int
    var color: String
    let imageId: Int
}

extension ProductVM: Hashable {
    static func == (lhs: ProductVM, rhs: ProductVM) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ProductVariantVM: Hashable {
    static func == (lhs: ProductVariantVM, rhs: ProductVariantVM) -> Bool {
        lhs.imageId == rhs.imageId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageId)
    }
}

//extension ProductDTO {
//    var asProductVM: ProductVM {
//        ProductVM(
//            id: self.id,
//            nameLabel: self.name.uppercased(),
//            type: self.type,
//            family: self.family,
//            gender: self.gender,
//            size: self.size,
//            geofit: self.geofit,
//            colorsLabel: "\(self.variations.count) COLORS",
//            variations: self.variations.asProductVariantsVM,
//            details: self.details,
//            images: (self.images ?? [])
//                        .map({UIImage(data: $0)})
//                        .compactMap({$0}) )
//    }
//}
//
//extension Array where Element == ProductDTO {
//    var asProductsVM: [ProductVM] {
//        self.map { item in
//            item.asProductVM
//        }
//    }
//}
//
//extension ProductVM {
//    static var emptyModel: ProductVM {
//        return ProductVM(
//            id: UUID().uuidString,
//            nameLabel: "",
//            type: "",
//            family: "",
//            gender: "",
//            size: "",
//            geofit: "",
//            colorsLabel: "",
//            variations: [],
//            details: "",
//            images: [])
//    }
//}
