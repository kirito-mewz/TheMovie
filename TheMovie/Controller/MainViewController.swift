//
//  ViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var movieTableView: UITableView!
    
    // MARK: - Properties
    var sliderMovies: [Movie]?
    var popularMovies: [Movie]?
    var popularSeries: [Movie]?
    var movieGenres: [GenreVO]?
    var showcaseMovies: [Movie]?
    var actors: [Actor]?
    
    var showcaseResponse: MovieResponse?
    var actorResponse: ActorResponse?
    
    let movieModel: MovieModel = MovieModelImpl.shared
    let genreModel: GenreModel = GenreModelImpl.shared
    let actorModel: ActorModel = ActorModelImpl.shared
    
    let rxMovieModel: RxMovieModel = RxMovieModelImpl.shared
    let rxGenreModel: RxGenreModel = RxGenreModelImpl.shared
    let rxActorModel: RxActorModel = RxActorModelImpl.shared
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [SliderTableViewCell.self,
         PopularTableViewCell.self,
         ShowtimeTableViewCell.self,
         MovieWithGenreTableViewCell.self,
         ShowcaseTableViewCell.self,
         ActorTableViewCell.self
        ].forEach {
            movieTableView.register(UINib(nibName: String(describing: $0), bundle: nil), forCellReuseIdentifier: String(describing: $0))
        }
        
        // loadData()
        rxLoadData()
    }

    @IBAction func onSearchTapped(_ sender: Any) {
        let vc = SearchViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public enum Section: Int, CaseIterable {
        case sliderMovies = 0
        case popularMovies = 1
        case popularSeries = 2
        case showtime = 3
        case movieWihtGenre = 4
        case showcase = 5
        case actor = 6
    }
    
    private func updateUI(at section: Section) {
        let indexSet = IndexSet(integer: section.rawValue)
        movieTableView.reloadSections(indexSet, with: .automatic)
    }
    
}

// MARK: - Delegates
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.sliderMovies.rawValue:
            let cell = dequeueTableViewCell(ofType: SliderTableViewCell.self, with: tableView, for: indexPath)
            cell.delegate = self
            cell.movies = sliderMovies
            return cell
        case Section.popularMovies.rawValue:
            let cell = dequeueTableViewCell(ofType: PopularTableViewCell.self, with: tableView, for: indexPath)
            cell.sectionTitleLabel.text = "BEST POPULAR MOVIES"
            cell.delegate = self
            cell.movies = popularMovies
            return cell
        case Section.popularSeries.rawValue:
            let cell = dequeueTableViewCell(ofType: PopularTableViewCell.self, with: tableView, for: indexPath)
            cell.sectionTitleLabel.text = "BEST POPULAR SERIES"
            cell.delegate = self
            cell.movies = popularSeries
            return cell
        case Section.showtime.rawValue:
            let cell = dequeueTableViewCell(ofType: ShowtimeTableViewCell.self, with: tableView, for: indexPath)
            return cell
        case Section.movieWihtGenre.rawValue:
            let cell = dequeueTableViewCell(ofType: MovieWithGenreTableViewCell.self, with: tableView, for: indexPath)
            cell.delegate = self
            cell.genres = movieGenres
            cell.movies = popularMovies
            return cell
        case Section.showcase.rawValue:
            let cell = dequeueTableViewCell(ofType: ShowcaseTableViewCell.self, with: tableView, for: indexPath)
            cell.onMoreShowcaseTapped = { [weak self] in
                let vc = ListViewController.instantiate()
                vc.type = .movie
                vc.showcaseResponse = self?.showcaseResponse
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.delegate = self
            cell.movies = showcaseMovies
            return cell
        case Section.actor.rawValue:
            let cell = dequeueTableViewCell(ofType: ActorTableViewCell.self, with: tableView, for: indexPath)
            cell.onMoreActorTapped = { [weak self] in
                let vc = ListViewController.instantiate()
                vc.type = .cast
                vc.actorResponse = self?.actorResponse
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.delegate = self
            cell.actors = actors
            return cell
        default :
            return UITableViewCell()
        }
    }
    
    private func dequeueTableViewCell<T: UITableViewCell>(ofType: T.Type, with tableView: UITableView, for indexPath: IndexPath, _ setupCell: ((T) -> Void) = {_ in}) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("ERROR: Fail to cast the given cell into \(T.self)")
        }
        setupCell(cell)
        return cell
    }
    
}

// MARK: - Data
extension MainViewController {
    
//    func loadData() {
//        
//        // Fetch slider movies
//        movieModel.getSliderMovies(pageNo: nil) { [weak self] result in
//            do {
//                self?.sliderMovies = try result.get().results
//                self?.updateUI(at: .sliderMovies)
//            } catch {
//                print("[Error: while fetching slider movies]", error)
//            }
//        }
//        
//        // Fetch popular movies
//        movieModel.getPopularMovies(pageNo: nil){ [weak self] result in
//            do {
//                self?.popularMovies = try result.get().results
//                self?.updateUI(at: .popularMovies)
//            } catch {
//                print("[Error: while fetching popular movies]", error)
//            }
//        }
//        
//        // Fetch popular series
//        movieModel.getPopularSeries(pageNo: nil) { [weak self] result in
//            do {
//                self?.popularSeries = try result.get().results
//                self?.updateUI(at: .popularSeries)
//            } catch {
//                print("[Error: while fetching popular series]", error)
//            }
//        }
//        
//        // Fetch genres
//        genreModel.getGenres { [weak self] result in
//            do {
//                let genres = try result.get()
//                self?.movieGenres = genres.map { $0.convertToGenreVO() }
//                self?.updateUI(at: .movieWihtGenre)
//            } catch {
//                print("[Error: while fetching genres]", error)
//            }
//        }
//        
//        // Fetch showcase movies
//        movieModel.getShowcaseMovies(pageNo: nil) { [weak self] result in
//            do {
//                self?.showcaseResponse = try result.get()
//                self?.showcaseMovies = self?.showcaseResponse?.results
//                self?.updateUI(at: .showcase)
//            } catch {
//                print("[Error: while fetching showcase movies]", error)
//            }
//        }
//        
//        // Fetch actor
//        actorModel.getActors(pageNo: nil) { [weak self] result in
//            do {
//                self?.actorResponse = try result.get()
//                self?.actors = self?.actorResponse?.results
//                self?.updateUI(at: .actor)
//            } catch {
//                print("[Error: while fetching actor]", error)
//            }
//        }
//        
//    }
    
    func rxLoadData() {
        
        rxMovieModel.getSliderMovies(pageNo: nil)
            .subscribe { [weak self] response in
                self?.sliderMovies = response.results
                self?.updateUI(at: .sliderMovies)
            } onError: { error in
                print("[Error: while fetching slider movies]", error)
            }
            .disposed(by: disposeBag)
        
        rxMovieModel.getPopularMovies(pageNo: nil)
            .subscribe { [weak self] response in
                self?.popularMovies = response.results
                self?.updateUI(at: .popularMovies)
            } onError: { error in
                print("[Error: while fetching popular movies]", error)
            }
            .disposed(by: disposeBag)
        
        rxMovieModel.getPopularSeries(pageNo: nil)
            .subscribe { [weak self] response in
                self?.popularSeries = response.results
                self?.updateUI(at: .popularSeries)
            } onError: { error in
                print("[Error: while fetching popular series]", error)
            }
            .disposed(by: disposeBag)
        
        rxGenreModel.getGenres()
            .subscribe { [weak self] genres in
                self?.movieGenres = genres.map { $0.convertToGenreVO() }
                self?.updateUI(at: .movieWihtGenre)
            } onError: { error in
                print("[Error: while fetching genres]", error)
            }
            .disposed(by: disposeBag)
        
        rxMovieModel.getShowcaseMovies(pageNo: nil)
            .subscribe { [weak self] response in
                self?.showcaseResponse = response
                self?.showcaseMovies = response.results
                self?.updateUI(at: .showcase)
            } onError: { error in
                print("[Error: while fetching showcase movies]", error)
            }
            .disposed(by: disposeBag)
        
        rxActorModel.getActors(pageNo: nil)
            .subscribe { [weak self] response in
                self?.actorResponse = response
                self?.actors = response.results
                self?.updateUI(at: .actor)
            } onError: { error in
                print("[Error: while fetching actors]", error)
            }
            .disposed(by: disposeBag)
    }
    
}

extension MainViewController: MovieItemDelegate, ActorItemDelegate {
    func onFavouriteTapped(isFavourite: Bool) { }
}

