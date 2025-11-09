//
//  MovieItemDelegate.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

protocol MovieItemDelegate {
    func onMovieCellTapped()
}

extension MovieItemDelegate where Self: UIViewController {
    func onMovieCellTapped() {
        let vc = MovieDetailViewController.instantiate()
        (self as UIViewController).navigationController?.pushViewController(vc, animated: true)
    }
}
