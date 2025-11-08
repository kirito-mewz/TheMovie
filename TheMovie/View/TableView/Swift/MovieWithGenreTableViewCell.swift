//
//  MovieWithGenreTableViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit

class MovieWithGenreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MovieWithGenreTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView {
            return 10
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollectionView {
            let cell = collectionView.dequeueCell(ofType: GenreCollectionViewCell.self, for: indexPath, shouldRegister: true)
            return cell
        } else {
            let cell = collectionView.dequeueCell(ofType: MovieCollectionViewCell.self, for: indexPath, shouldRegister: true)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genreCollectionView {
            return .init(width: 100, height: 40)
        } else {
            return .init(width: collectionView.frame.width / 3, height:collectionView.frame.height)
        }
    }
    
    
    
}
