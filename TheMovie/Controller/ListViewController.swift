//
//  ListViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

class ListViewController: UIViewController, Storyboarded {
    
    enum ListType { case movie, cast }
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var upButton: UIButton!
    
    // MARK: - Properties
    var type: ListType = .movie
    
    var currentPage = 1
    var noOfPages = 1
    
    var movies: [Movie] = []
    var actors: [Actor] = []
    var showcaseResponse: MovieResponse?
    var actorResponse: ActorResponse?
    
    let movieModel: MovieModel = MovieModelImpl.shared
    let actorModel: ActorModel = ActorModelImpl.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = type == .movie ? "Showcase Movies" : "Popular Actors"
        upButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        setupInitialData()
        
    }
    
    @IBAction func onUpButtonTapped(_ sender: Any) {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func setupInitialData() {
        if type == .movie {
            showcaseResponse?.results?.forEach { movies.append($0) }
            currentPage = showcaseResponse?.page ?? 1
            noOfPages = showcaseResponse?.totalPages ?? 1
        } else {
            actorResponse?.results?.forEach { actors.append($0) }
            currentPage = actorResponse?.page ?? 1
            noOfPages = actorResponse?.totalPages ?? 1
        }
        collectionView.reloadData()
    }
    
}

extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return type == .movie ? movies.count : actors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if type == .movie {
            let cell = collectionView.dequeueCell(ofType: ShowcaseCollectionViewCell.self, for: indexPath, shouldRegister: true)
            cell.movie = movies[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueCell(ofType: ActorCollectionViewCell.self, for: indexPath, shouldRegister: true)
            cell.actor = actors[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if type == .movie {
            return .init(width: collectionView.frame.width - 40, height: collectionView.frame.height / 4)
        } else {
            return .init(width: (collectionView.frame.width / 3) + 30, height: collectionView.frame.height / 3)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.frame.height / 2 {
            upButton.isHidden = false
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.upButton.transform = .identity
            }
        } else {
            if upButton.transform.isIdentity {
                UIView.animate(withDuration: 0.5) { [weak self] in
                    self?.upButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == .movie {
            self.onMovieCellTapped()
        } else {
            self.onActorCellTapped()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = indexPath.row == (type == .movie ? movies.count - 1: actors.count - 1)
        if lastRow && currentPage <= noOfPages { loadNewPages(pageNo: currentPage + 1) }
    }
}

extension ListViewController {
    
    func loadNewPages(pageNo: Int) {
        if type == .movie {
            loadMovies(pageNo: pageNo)
        } else {
            loadActors(pageNo: pageNo)
        }
    }

    func loadMovies(pageNo: Int) {
        movieModel.getShowcaseMovies(pageNo: pageNo) { [weak self] result in
            do {
                let response = try result.get()
                response.results?.forEach { self?.movies.append($0) }
                self?.collectionView.reloadData()
                self?.currentPage += 1
            } catch {
                print("[Error: while fetching showcase movies]", error)
            }
        }
    }
    
    func loadActors(pageNo: Int) {
        actorModel.getActors(pageNo: pageNo) { [weak self] result in
            do {
                let response = try result.get()
                response.results?.forEach { self?.actors.append($0) }
                self?.collectionView.reloadData()
                self?.currentPage += 1
            } catch {
                print("[Error: while fetching actors]", error)
            }
        }
    }
    
}

extension ListViewController: MovieItemDelegate, ActorItemDelegate {
    func onFavouriteTapped(isFavourite: Bool) { }
}
