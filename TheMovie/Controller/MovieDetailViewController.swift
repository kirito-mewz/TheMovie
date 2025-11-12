//
//  MovieDetailViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit
import SDWebImage

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
    
    // MARK: - Properties
    var movieId: Int = -1
    var type: MovieType = .movie
    
    var movieDetail: MovieDetailResponse?
    var movieActors: [Actor]?
    var companies: [ProductionCompany]?
    var similarMovies: [Movie]?
    
    let movieModel: MovieModel = MovieModelImpl.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        configureButton()
        
        loadData()
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
        self.playTrailer()
//        let vc = YoutubePlayerViewController.instantiate()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func bindData(with detail: MovieDetailResponse?) {
        
        guard let data = detail else { return }
        
        if let image = data.backdropPath {
            movieImageView.sd_setImage(with: URL(string: "\(imageBaseURL)/\(image)"))
        }
        
        if type == .movie {
            releasedYearLabel.text = String(data.releaseDate?.split(separator: "-").first ?? "")
            movieTitleLabel.text = data.title
            
            let hour = (data.runtime ?? 0) / 60
            let minute = (data.runtime ?? 0) - (hour * 60)
            durationLabel.text = "\(hour)h \(minute)min"
            
            originalTitleLabel.text = data.originalTitle
            releasedDateLabel.text = data.convertToMovieDate(date: data.releaseDate ?? "")
        } else {
            releasedYearLabel.text = String(data.lastAirDate?.split(separator: "-").first ?? "")
            movieTitleLabel.text = data.name
            
            durationLabel.text = "\(data.noOfSeasons ?? 1) \(data.noOfSeasons ?? 1 > 1 ? "Season" : "Seasons")"
            
            originalTitleLabel.text = data.originalName
            releasedDateLabel.text = data.convertToMovieDate(date: data.lastAirDate ?? "")
        }
        
        voteCountLabel.text = "\(data.voteCount ?? 0) VOTES"
        ratingControl.rating = Int(round(data.voteAverage ?? 0) * 0.5)
        popularityLabel.text = String(format: "%.1f", data.popularity ?? 0)
        storylineLabel.text = data.overview
        
        var rawGenres = data.genres?.map { $0.name }.reduce("") { "\($0 ?? "")\($1 ?? ""), " }
        if (rawGenres?.count ?? 0) >= 2 { rawGenres?.removeLast(2) }
        genreLabel.text = rawGenres
        
        var rawCompanies = data.productionCompanies?.map { $0.name }.reduce("") { "\($0 ?? "")\($1 ?? ""), " }
        if (rawCompanies?.count ?? 0) >= 2 { rawCompanies?.removeLast(2) }
        companiesLabel.text = rawCompanies
        
        movieDescriptionLabel.text = data.overview ?? "No Description"
        
        companies = data.productionCompanies
        
        companiesCollectionView.reloadData()
        badgeCollectionView.reloadData()
        
    }
    
}


extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == badgeCollectionView {
            return movieDetail?.genres?.count ?? 0
        } else if collectionView == actorCollectionView {
            return movieActors?.count ?? 0
        } else if collectionView == companiesCollectionView {
            return companies?.count ?? 0
        } else {
            return similarMovies?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == badgeCollectionView {
            let cell = collectionView.dequeueCell(ofType: BadgeCollectionViewCell.self, for: indexPath, shouldRegister: true)
            cell.genre = movieDetail?.genres?[indexPath.row]
            return cell
        } else if collectionView == actorCollectionView {
            let cell = collectionView.dequeueCell(ofType: ActorCollectionViewCell.self, for: indexPath, shouldRegister: true)
            cell.actor = movieActors?[indexPath.row]
            cell.delegate = self
            return cell
        } else if collectionView == companiesCollectionView {
            let cell = collectionView.dequeueCell(ofType: CompanyCollectionViewCell.self, for: indexPath, shouldRegister: true)
            cell.company = companies?[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueCell(ofType: MovieCollectionViewCell.self, for: indexPath, shouldRegister: true)
            cell.movie = similarMovies?[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == badgeCollectionView {
            let genreName = movieDetail?.genres?[indexPath.row].name ?? ""
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
            self.onMovieCellTapped(movieId: similarMovies?[indexPath.row].id, type: .movie)
        }
    }
    
}

extension MovieDetailViewController {
    
    func loadData() {
        movieModel.getMovieDetail(movieId: movieId, type: self.type) { [weak self] result in
            do {
                let response = try result.get()
                self?.movieDetail = response
                self?.bindData(with: response)
                self?.navigationItem.title = response.title ?? response.name
            } catch {
                print("[Error: while fetching movie detail]", error)
            }
        }
        fetchMovieCredits()
        fetchSimilarMovies()
    }
    
    func playTrailer() {
        movieModel.getMovieTrailer(movieId: movieId, type: self.type) { [weak self] result in
            do {
                let response = try result.get()
                print(response.id)
            } catch {
                print("[Error: while fetching movie trailer]", error)
            }
        }
    }
    
    func fetchMovieCredits() {
        movieModel.getMovieActors(movieId: movieId, type: self.type) { [weak self] result in
            do {
                self?.movieActors = try result.get()
                self?.actorCollectionView.reloadData()
            } catch {
                print("[Error: while fetching movie actors]", error)
            }
        }
    }
    
    func fetchSimilarMovies() {
        movieModel.getSimilarMovies(movieId: movieId, type: self.type) { [weak self] result in
            do {
                self?.similarMovies = try result.get().results
                self?.movieCollectionView.reloadData()
            } catch {
                print("[Error: while fetching similar movies ]", error)
            }
        }
    }
    
}

extension MovieDetailViewController: MovieItemDelegate, ActorItemDelegate {
    func onFavouriteTapped(isFavourite: Bool) { }
}

