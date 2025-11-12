//
//  MovieItemDelegate.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

protocol MovieItemDelegate {
    func onMovieCellTapped(movieId: Int?, type: MovieType)
}

extension MovieItemDelegate where Self: UIViewController {
    func onMovieCellTapped(movieId: Int?, type: MovieType) {
        let vc = MovieDetailViewController.instantiate()
        vc.movieId = movieId ?? -1
        vc.type = type
        (self as UIViewController).navigationController?.pushViewController(vc, animated: true)
    }
}
