//
//  MovieDetailViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
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

}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == badgeCollectionView {
            return 5
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
            return .init(width: 50, height: collectionView.frame.height)
        } else if collectionView == actorCollectionView {
            return .init(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
        } else if collectionView == companiesCollectionView {
            return .init(width: 100, height: 100)
        } else {
            return .init(width: collectionView.frame.width / 3, height: collectionView.frame.height)
        }
    }
    
    
    
}

