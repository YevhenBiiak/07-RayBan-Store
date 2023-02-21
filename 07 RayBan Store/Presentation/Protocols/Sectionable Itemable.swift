//
//  Sectionable Itemable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 10.02.2023.
//

import Foundation

protocol Sectionable {
    var header: String? { get }
    var items: [any Itemable] { get set }
}

extension Sectionable {
    mutating func insert(_ item: any Itemable, at index: Int) {
        index < items.count
            ? items[index] = item
            : items.append(item)
    }
}

protocol Itemable {
    associatedtype ViewModel
    var viewModel: ViewModel? { get }
}
