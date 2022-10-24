//
//  Array +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 24.10.2022.
//

extension Array where Element: Equatable {
    func insertedDifference(from other: Self) -> Self {
        let difference = difference(from: other)
        var insertedElements: Self = []
        for case let .insert(_, new, _) in difference {
            insertedElements.append(new)
        }
        return insertedElements
    }
    
    func removedDifference(from other: Self) -> Self {
        let difference = difference(from: other)
        var insertedElements: Self = []
        for case let .remove(_, new, _) in difference {
            insertedElements.append(new)
        }
        return insertedElements
    }
}
