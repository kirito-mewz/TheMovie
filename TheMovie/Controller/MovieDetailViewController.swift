//
//  MovieDetailViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

class MovieDetailViewController: UIViewController, Storyboarded {
    
    // MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!

    @IBOutlet weak var releasedYearLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var badgeCollectionView: UICollectionView!
    
    @IBOutlet weak var storylineLabel: UILabel!
    @IBOutlet weak var playTrailerButton: UIButton!
    @IBOutlet weak var rateMovieButton: UIButton!
    
    @IBOutlet weak var actorCollectionView: UICollectionView!
    
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var companiesLabel: UILabel!
    @IBOutlet weak var releasedDateLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    @IBOutlet weak var companiesCollectionView: UICollectionView!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    fileprivate var genreList: [GenreVO] = [
        .init(id: 1, genreName: "ACTION", isSelected: true),
        .init(id: 2, genreName: "ADVENTURE", isSelected: false),
        .init(id: 3, genreName: "CRIMINAL", isSelected: false),
        .init(id: 4, genreName: "DRAMMA", isSelected: false),
        .init(id: 5, genreName: "COMEDY", isSelected: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientLayer()
        configureButton()
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.init(named: "Color_Dark_Blue")!.cgColor]
        gradientLayer.locations = [0, 0.8]
        movieImageView.layer.addSublayer(gradientLayer)

        let gradientHeight = movieImageView.frame.height * 0.5
        gradientLayer.frame = CGRect(x: 0, y: movieImageView.frame.height - gradientHeight, width: view.frame.width, height: gradientHeight)
    }
    
    func configureButton() {
        playTrailerButton.layer.cornerRadius = playTrailerButton.frame.height / 2
        
        rateMovieButton.layer.borderColor = UIColor.white.cgColor
        rateMovieButton.layer.borderWidth = 1
        rateMovieButton.layer.cornerRadius = rateMovieButton.frame.height / 2
    }
    
    
    @IBAction func onPlayTrailerButton(_ sender: Any) {
        let vc = YoutubePlayerViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == badgeCollectionView {
            return genreList.count
        } else if collectionView == actorCollectionView {
            return 10
        } else if collectionView == companiesCollectionView {
            return 5
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == badgeCollectionView {
            let cell = collectionView.dequeueCell(ofType: BadgeCollectionViewCell.self, for: indexPath, shouldRegister: true)
            cell.data = genreList[indexPath.row]
            return cell
        } else if collectionView == actorCollectionView {
            let cell = collectionView.dequeueCell(ofType: ActorCollectionViewCell.self, for: indexPath, shouldRegister: true)
            return cell
        } else if collectionView == companiesCollectionView {
            let cell = collectionView.dequeueCell(ofType: CompanyCollectionViewCell.self, for: indexPath, shouldRegister: true)
            return cell
        } else {
            let cell = collectionView.dequeueCell(ofType: MovieCollectionViewCell.self, for: indexPath, shouldRegister: true)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == badgeCollectionView {
            let genreName = genreList[indexPath.row].genreName
            let textWidth = genreName.getWidth(of: UIFont.systemFont(ofSize: 14))
            return .init(width: textWidth + 20, height: collectionView.frame.height)
        } else if collectionView == actorCollectionView {
            return .init(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
        } else if collectionView == companiesCollectionView {
            return .init(width: 100, height: 100)
        } else {
            return .init(width: collectionView.frame.width / 3, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == actorCollectionView{
            self.onActorCellTapped()
        } else if collectionView == movieCollectionView {
            self.onMovieCellTapped()
        }
    }
    
}

extension MovieDetailViewController: MovieItemDelegate, ActorItemDelegate {
    func onFavouriteTapped(isFavourite: Bool) { }
}

