//
//  ActorItemDelegate.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

protocol ActorItemDelegate {
    func onFavouriteTapped(isFavourite: Bool)
    func onActorCellTapped(actorId: Int?)
}

extension ActorItemDelegate where Self: UIViewController {
    func onActorCellTapped(actorId: Int?) {
        let vc = ActorDetailViewController.instantiate()
        vc.actorId = actorId ?? -1
        (self as UIViewController).navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
