//
//  ViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit
import RxSwift
import RxDataSources
internal import RxCocoa

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var movieTableView: UITableView!
    
    // MARK: - Properties
//    var sliderMovies: [Movie]?
//    var popularMovies: [Movie]?
//    var popularSeries: [Movie]?
//    var movieGenres: [GenreVO]?
//    var showcaseMovies: [Movie]?
//    var actors: [Actor]?
//    
//    var showcaseResponse: MovieResponse?
//    var actorResponse: ActorResponse?
//    
//    let movieModel: MovieModel = MovieModelImpl.shared
//    let genreModel: GenreModel = GenreModelImpl.shared
//    let actorModel: ActorModel = ActorModelImpl.shared
    
    var observableSliderMovies: BehaviorSubject<[Movie]> = BehaviorSubject(value: [])
    var observablePopularMovies: BehaviorSubject<[Movie]> = BehaviorSubject(value: [])
    var observablePopularSeries: BehaviorSubject<[Movie]> = BehaviorSubject(value: [])
    var observableGenres: BehaviorSubject<[GenreVO]> = BehaviorSubject(value: [])
    var observableShowcaseResponse: BehaviorSubject<MovieResponse?> = BehaviorSubject(value: nil)
    var observableActorResponse: BehaviorSubject<ActorResponse?> = BehaviorSubject(value: nil)
    
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
        
        let dataSource = initDatasource()
        
        let showcaseMovies = observableShowcaseResponse
            .map { $0?.results ?? [] }

        let actorList = observableActorResponse
            .map { $0?.results ?? [] }
        
        Observable.combineLatest(
            observableSliderMovies,
            observablePopularMovies,
            observablePopularSeries,
            showcaseMovies,
            actorList
        )
        .flatMapLatest { (sliderMovies, popularMovies, popularSeries, showcaseMovies, actors) -> Observable<[MainSectionModel]> in
            
            var items = [MainSectionModel]()
            
            if !sliderMovies.isEmpty {
                items.append(.SliderMovies(items: [.SliderMovieSectionItems(items: sliderMovies)]))
            }
            
            if !popularMovies.isEmpty {
                items.append(.PopularMovies(items: [.PopularMovieSectionItems(items: popularMovies)]))
            }
            
            if !popularSeries.isEmpty {
                items.append(.PopularSeries(items: [.PopularSerieSectionItems(items: popularSeries)]))
            }

            items.append(.ShowtimeMovie(items: .ShowtimeMovieSectionItems(items: "")))
            
            items.append(.MovieWithGenre(items: [.MovieWihtGenreSectionItems(items: popularMovies)]))

            if !showcaseMovies.isEmpty {
                items.append(.ShowcaseMovies(items: [.ShowcaseMovieSectionItems(items: showcaseMovies)]))
            }
            
            if !actors.isEmpty {
                items.append(.PopularActor(items: [.PopularActorSectionItems(items: actors)]))
            }
            
            return .just(items)
        }
        .bind(to: movieTableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }

    @IBAction func onSearchTapped(_ sender: Any) {
        let vc = SearchViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func initDatasource() -> RxTableViewSectionedReloadDataSource<MainSectionModel> {
        RxTableViewSectionedReloadDataSource<MainSectionModel> { dataSource, tableView, indexPath, item in
            switch item {
            case .SliderMovieSectionItems(let item):
                let cell = self.dequeueTableViewCell(ofType: SliderTableViewCell.self, with: tableView, for: indexPath)
                cell.delegate = self
                cell.movies = item
                return cell
            case .PopularMovieSectionItems(let item):
                let cell = self.dequeueTableViewCell(ofType: PopularTableViewCell.self, with: tableView, for: indexPath)
                cell.delegate = self
                cell.sectionTitleLabel.text = "BEST POPULAR MOVIES"
                cell.movies = item
                return cell
            case .PopularSerieSectionItems(let item):
                let cell = self.dequeueTableViewCell(ofType: PopularTableViewCell.self, with: tableView, for: indexPath)
                cell.delegate = self
                cell.sectionTitleLabel.text = "BEST POPULAR SERIES"
                cell.movies = item
                return cell
            case .ShowtimeMovieSectionItems(_):
                return self.dequeueTableViewCell(ofType: ShowtimeTableViewCell.self, with: tableView, for: indexPath)
            case .MovieWihtGenreSectionItems(let item):
                let cell = self.dequeueTableViewCell(ofType: MovieWithGenreTableViewCell.self, with: tableView, for: indexPath)
                cell.delegate = self
                cell.genres = try! self.observableGenres.value()
                cell.movies = item
                return cell
            case .ShowcaseMovieSectionItems(let item):
                let cell = self.dequeueTableViewCell(ofType: ShowcaseTableViewCell.self, with: tableView, for: indexPath)
                cell.onMoreShowcaseTapped = { [weak self] in
                    let vc = ListViewController.instantiate()
                    vc.type = .movie
                    vc.showcaseResponse = try! self?.observableShowcaseResponse.value()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                cell.delegate = self
                cell.movies = item
                return cell
            case .PopularActorSectionItems(let item):
                let cell = self.dequeueTableViewCell(ofType: ActorTableViewCell.self, with: tableView, for: indexPath)
                cell.onMoreActorTapped = { [weak self] in
                    let vc = ListViewController.instantiate()
                    vc.type = .cast
                    vc.actorResponse = try! self?.observableActorResponse.value()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                cell.delegate = self
                cell.actors = item
                return cell
            }
        }
    }
    
    private func dequeueTableViewCell<T: UITableViewCell>(ofType: T.Type, with tableView: UITableView, for indexPath: IndexPath, _ setupCell: ((T) -> Void) = {_ in}) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("ERROR: Fail to cast the given cell into \(T.self)")
        }
        setupCell(cell)
        return cell
    }
    
    
//    public enum Section: Int, CaseIterable {
//        case sliderMovies = 0
//        case popularMovies = 1
//        case popularSeries = 2
//        case showtime = 3
//        case movieWihtGenre = 4
//        case showcase = 5
//        case actor = 6
//    }
//    
//    private func updateUI(at section: Section) {
//        let indexSet = IndexSet(integer: section.rawValue)
//        movieTableView.reloadSections(indexSet, with: .automatic)
//    }
    
}

// MARK: - Delegates
extension MainViewController: UITableViewDelegate {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return Section.allCases.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case Section.sliderMovies.rawValue:
//            let cell = dequeueTableViewCell(ofType: SliderTableViewCell.self, with: tableView, for: indexPath)
//            cell.delegate = self
//            cell.movies = sliderMovies
//            return cell
//        case Section.popularMovies.rawValue:
//            let cell = dequeueTableViewCell(ofType: PopularTableViewCell.self, with: tableView, for: indexPath)
//            cell.sectionTitleLabel.text = "BEST POPULAR MOVIES"
//            cell.delegate = self
//            cell.movies = popularMovies
//            return cell
//        case Section.popularSeries.rawValue:
//            let cell = dequeueTableViewCell(ofType: PopularTableViewCell.self, with: tableView, for: indexPath)
//            cell.sectionTitleLabel.text = "BEST POPULAR SERIES"
//            cell.delegate = self
//            cell.movies = popularSeries
//            return cell
//        case Section.showtime.rawValue:
//            let cell = dequeueTableViewCell(ofType: ShowtimeTableViewCell.self, with: tableView, for: indexPath)
//            return cell
//        case Section.movieWihtGenre.rawValue:
//            let cell = dequeueTableViewCell(ofType: MovieWithGenreTableViewCell.self, with: tableView, for: indexPath)
//            cell.delegate = self
//            cell.genres = movieGenres
//            cell.movies = popularMovies
//            return cell
//        case Section.showcase.rawValue:
//            let cell = dequeueTableViewCell(ofType: ShowcaseTableViewCell.self, with: tableView, for: indexPath)
//            cell.onMoreShowcaseTapped = { [weak self] in
//                let vc = ListViewController.instantiate()
//                vc.type = .movie
//                vc.showcaseResponse = self?.showcaseResponse
//                self?.navigationController?.pushViewController(vc, animated: true)
//            }
//            cell.delegate = self
//            cell.movies = showcaseMovies
//            return cell
//        case Section.actor.rawValue:
//            let cell = dequeueTableViewCell(ofType: ActorTableViewCell.self, with: tableView, for: indexPath)
//            cell.onMoreActorTapped = { [weak self] in
//                let vc = ListViewController.instantiate()
//                vc.type = .cast
//                vc.actorResponse = self?.actorResponse
//                self?.navigationController?.pushViewController(vc, animated: true)
//            }
//            cell.delegate = self
//            cell.actors = actors
//            return cell
//        default :
//            return UITableViewCell()
//        }
//    }
//    
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
                self?.observableSliderMovies.onNext(response.results ?? [])
            } onError: { error in
                print("[Error: while fetching slider movies]", error)
            }
            .disposed(by: disposeBag)
        
        rxMovieModel.getPopularMovies(pageNo: nil)
            .subscribe { [weak self] response in
                self?.observablePopularMovies.onNext(response.results ?? [])
            } onError: { error in
                print("[Error: while fetching popular movies]", error)
            }
            .disposed(by: disposeBag)
        
        rxMovieModel.getPopularSeries(pageNo: nil)
            .subscribe { [weak self] response in
                self?.observablePopularSeries.onNext(response.results ?? [])
            } onError: { error in
                print("[Error: while fetching popular series]", error)
            }
            .disposed(by: disposeBag)
        
        rxGenreModel.getGenres()
            .map { genres -> [GenreVO] in
                genres.map { $0.convertToGenreVO() }
            }
            .subscribe { [weak self] genres in
                self?.observableGenres.onNext(genres)
            } onError: { error in
                print("[Error: while fetching genres]", error)
            }
            .disposed(by: disposeBag)
        
        rxMovieModel.getShowcaseMovies(pageNo: nil)
            .subscribe { [weak self] response in
                self?.observableShowcaseResponse.onNext(response)
            } onError: { error in
                print("[Error: while fetching showcase movies]", error)
            }
            .disposed(by: disposeBag)
        
        rxActorModel.getActors(pageNo: nil)
            .subscribe { [weak self] response in
                self?.observableActorResponse.onNext(response)
            } onError: { error in
                print("[Error: while fetching actors]", error)
            }
            .disposed(by: disposeBag)
    }
    
}

extension MainViewController: MovieItemDelegate, ActorItemDelegate {
    func onFavouriteTapped(isFavourite: Bool) { }
}

// MARK: - Model
enum MainSectionModel: SectionModelType {
    
    var items: [SectionItem] {
        switch self {
        case .SliderMovies(let item): return item
        case .PopularMovies(let item): return item
        case .PopularSeries(let item): return item
        case .ShowtimeMovie(let item): return [item]
        case .MovieWithGenre(let item): return item
        case .ShowcaseMovies(let item): return item
        case .PopularActor(let item): return item
        }
    }
    
    init(original: MainSectionModel, items: [SectionItem]) {
        switch original {
        case .SliderMovies(let item):
            self = .SliderMovies(items: item)
        case .PopularMovies(let item):
            self = .PopularMovies(items: item)
        case .PopularSeries(let item):
            self = .PopularSeries(items: item)
        case .ShowtimeMovie(let item):
            self = .ShowtimeMovie(items: item)
        case .MovieWithGenre(let item):
            self = .MovieWithGenre(items: item)
        case .ShowcaseMovies(let item):
            self = .ShowcaseMovies(items: item)
        case .PopularActor(let item):
            self = .PopularActor(items: item)
        }
    }
    
    typealias Item = SectionItem

    enum SectionItem {
        case SliderMovieSectionItems(items: [Movie])
        case PopularMovieSectionItems(items: [Movie])
        case PopularSerieSectionItems(items: [Movie])
        case ShowtimeMovieSectionItems(items: String)
        case MovieWihtGenreSectionItems(items: [Movie])
        case ShowcaseMovieSectionItems(items: [Movie])
        case PopularActorSectionItems(items: [Actor])
    }
    
    case SliderMovies(items: [SectionItem])
    case PopularMovies(items: [SectionItem])
    case PopularSeries(items: [SectionItem])
    case ShowtimeMovie(items: SectionItem)
    case MovieWithGenre(items: [SectionItem])
    case ShowcaseMovies(items: [SectionItem])
    case PopularActor(items: [SectionItem])
    
}

