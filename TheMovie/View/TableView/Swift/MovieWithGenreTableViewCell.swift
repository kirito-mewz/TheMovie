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

    var movieDict: [Int: Set<Movie>] = [:]
    
    var genres: [GenreVO]? {
        didSet {
            genres?.first?.isSelected = true
            genreCollectionView.reloadData()
            
            reloadMovies(basedOn: genres?.first?.id ?? 0)
        }
    }
    
    var movies: [Movie]? {
        didSet {
            guard let movies = movies else { return }
            organizeMoviesBasedOnGenre(movies)
        }
    }
    
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
        return collectionView == genreCollectionView ? genres?.count ?? 0 : movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollectionView {
            let cell = collectionView.dequeueCell(ofType: GenreCollectionViewCell.self, for: indexPath, shouldRegister: true)
            cell.genre = genres?[indexPath.row]
            
            cell.onGenreTap = { genreId in
                self.resetGenreSelection(genreId)
                self.reloadMovies(basedOn: genreId)
            }
            return cell
        } else {
            let cell = collectionView.dequeueCell(ofType: MovieCollectionViewCell.self, for: indexPath, shouldRegister: true)
            cell.movie = movies?[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genreCollectionView {
            let genreName = genres?[indexPath.row].genreName ?? ""
            let textWidth = genreName.getWidth(of: UIFont.systemFont(ofSize: 14))
            return .init(width: textWidth + 20, height: 40)
        } else {
            return .init(width: collectionView.frame.width / 3, height:collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         delegate?.onMovieCellTapped()
    }
    
}


extension MovieWithGenreTableViewCell {
    
    private func resetGenreSelection(_ genreId: Int) {
        genres?.forEach { genre  in
            if genre.id == genreId {
                genre.isSelected = true
            } else {
                genre.isSelected = false
            }
        }
        genreCollectionView.reloadData()
    }

    private func organizeMoviesBasedOnGenre(_ movies: [Movie]) {
        movies.forEach { movie in
            movie.genreIds?.forEach { genreId in
                if let _ = movieDict[genreId] {
                    movieDict[genreId]?.insert(movie)
                } else {
                    movieDict[genreId] = [movie]
                }
            }
        }
    }
    
    private func reloadMovies(basedOn genreId: Int) {
        movies = movieDict[genreId]?.map { $0 }
        movieCollectionView.reloadData()
    }
    
}
