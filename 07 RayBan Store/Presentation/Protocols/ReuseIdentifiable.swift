//
//  ReuseIdentifiable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 06.03.2023.
//

import UIKit

protocol ReuseIdentifiable {}

extension ReuseIdentifiable {
    static var reuseId: String {
        String(describing: self)
    }
}

extension UICollectionReusableView: ReuseIdentifiable {}

extension UITableViewCell: ReuseIdentifiable {}

extension UICollectionView {
    
    func dequeueReusableCell<Cell>(_ type: Cell.Type, for indexPath: IndexPath, configurationHandler: (Cell) -> Void) ->
    UICollectionViewCell where Cell: UICollectionViewCell, Cell: ReuseIdentifiable {
        
        let cell: Cell! = dequeueReusableCell(withReuseIdentifier: Cell.reuseId, for: indexPath) as? Cell
        configurationHandler(cell)
        return cell
    }
    
//    func dequeueRegisteredCell<Cell>(_ type: Cell.Type, for indexPath: IndexPath, configurationHandler: (Cell) -> Void) ->
//    UICollectionViewCell where Cell: UICollectionViewCell, Cell: ReuseIdentifiable {
//        let cellRegistration = UICollectionView.CellRegistration<Cell == Cell> { (cell, _, product) in
//                
//            }
//        
//        let cell: Cell! = dequeueConfiguredReusableCell(using: cellRegistration(), for: indexPath, item: nil)
//    }
    
}
