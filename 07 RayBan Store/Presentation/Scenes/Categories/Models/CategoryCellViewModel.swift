//
//  CategoryCellViewModel.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.10.2022.
//

import Foundation

struct CategorySection: Sectionable {
    var header: String?
    var items: [any Itemable]
}

struct CategoryItem: Itemable {
    var viewModel: CategoryCellViewModel?
}

struct CategoryCellViewModel {
    let name: String
    var imageData: Data?
}
