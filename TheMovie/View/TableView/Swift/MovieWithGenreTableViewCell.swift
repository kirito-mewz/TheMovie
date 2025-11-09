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
    
    var delegate: MovieItemDelegate?
    
    fileprivate var genreList: [GenreVO] = [
        .init(id: 1, genreName: "ACTION", isSelected: true),
        .init(id: 2, genreName: "ADVENTURE", isSelected: false),
        .init(id: 3, genreName: "CRIMINAL", isSelected: false),
        .init(id: 4, genreName: "DRAMMA", isSelected: false),
        .init(id: 5, genreName: "COMEDY", isSelected: false),
        .init(id: 6, genreName: "DOCUMENTARY", isSelected: false),
        .init(id: 7, genreName: "BIOGRAPHY", isSelected: false),
    ]
    
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
            return genreList.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollectionView {
            let cell = collectionView.dequeueCell(ofType: GenreCollectionViewCell.self, for: indexPath, shouldRegister: true)
            cell.data = genreList[indexPath.row]
            
            cell.onGenreTap = { genreId in
                self.resetGenreSelection(genreId)
                self.genreCollectionView.reloadData()
            }
            return cell
        } else {
            let cell = collectionView.dequeueCell(ofType: MovieCollectionViewCell.self, for: indexPath, shouldRegister: true)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genreCollectionView {
            let genreName = genreList[indexPath.row].genreName
            let textWidth = genreName.getWidth(of: UIFont.systemFont(ofSize: 14))
            return .init(width: textWidth + 20, height: 40)
        } else {
            return .init(width: collectionView.frame.width / 3, height:collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // delegate?.onMovieCellTapped()
    }
    
    func resetGenreSelection(_ genreId: Int) {
        genreList.forEach { genre in
            if genre.id == genreId {
                genre.isSelected = true
            } else {
                genre.isSelected = false
            }
        }
    }
    
}
