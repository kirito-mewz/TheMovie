//
//  ActorDetailViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit
import SDWebImage

class ActorDetailViewController: UIViewController, Storyboarded {
    
    // MARK: - IBOutlets
    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var detailNamelLabel: UILabel!
    @IBOutlet weak var detailAkaLabel: UILabel!
    @IBOutlet weak var detailBirthdayLabel: UILabel!
    @IBOutlet weak var detailPobLabel: UILabel!
    @IBOutlet weak var detailRoleLabel: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    // MARK: - Properties
    var actorId: Int = -1
    
    var actorDetail: ActorDetailResponse?
    var movies: [Movie] = []
    
    let actorModel: ActorModel = ActorModelImpl.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    func bindData(with detail: ActorDetailResponse?) {
        
        guard let data = detail else { return }
        
        if let image = data.profilePath {
            actorImageView.sd_setImage(with: URL(string: "\(imageBaseURL)/\(image)"))
        }
        
        actorNameLabel.text = data.name
        roleLabel.text = data.gender == 1 ? "Actress" : "Actor"
        popularityLabel.text = String(format: "%.2f", data.popularity ?? 0.0)
        biographyLabel.text = data.biography
        
        detailNamelLabel.text = data.name
        
        var rawAkaNames = data.alsoKnownAs?.map { $0 }.reduce("") { "\($0 ?? "")\($1), " }
        if let akaNames = rawAkaNames, akaNames.count > 2 { rawAkaNames!.removeLast(2) }
        detailAkaLabel.text = rawAkaNames
        
        detailBirthdayLabel.text = data.birthday
        detailPobLabel.text = data.placeOfBirth
        detailRoleLabel.text = data.gender == 1 ? "Actress" : "Actor"
        
    }

}

// MARK: - Delegates
extension ActorDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: MovieCollectionViewCell.self, for: indexPath, shouldRegister: true)
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = movies[indexPath.row]
        self.onMovieCellTapped(
            movieId: item.id,
            type: (item.mediaType ?? "movies") == "movie" ? .movie : .series
        )
    }
    
}

// MARK: - Data
extension ActorDetailViewController {
    
    func loadData() {
        actorModel.getActorDetail(actorId: actorId) { [weak self] result in
            do {
                let response = try result.get()
                self?.actorDetail = response
                self?.bindData(with: response)
                self?.navigationItem.title = response.name
            } catch {
                print("[Error: while fetching actor detail]", error)
            }
        }
        
        actorModel.getActorMovies(actorId: actorId) { [weak self] result in
            do {
                let response = try result.get()
                response.movies?.forEach { self?.movies.append($0.convertToMovie()) }
                self?.movieCollectionView.reloadData()
            } catch {
                print("[Error: while fetching actor movies]", error)
            }
        }
    }
    
}

extension ActorDetailViewController: MovieItemDelegate {
    
}
