//
//  UICollectionView+Ext.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit

extension UICollectionView {
    
    func registerCellWithNib<T: UICollectionViewCell>(_ cell: T.Type) {
        register(UINib(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueCell<T: UICollectionViewCell>(
        ofType type: T.Type,
        for indexPath: IndexPath,
        shouldRegister: Bool = false,
        _ setupCell: ((T) -> Void) = {_ in}
    ) -> T {
        
        if shouldRegister {
            self.registerCellWithNib(T.self)
        }
        
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("ERROR: Fail to dequeue the given cell into: \(T.self)")
        }
        setupCell(cell)
        return cell
        
    }
    
}
