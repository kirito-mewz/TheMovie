//
//  ViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var movieTableView: UITableView!
    
    // MARK: - Properties
    var sliderMovies: [Movie]?
    var popularMovies: [Movie]?
    var popularSeries: [Movie]?

    
    let movieModel: MovieModel = MovieModelImpl.shared
    
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
        
        loadData()
    }

    @IBAction func onSearchTapped(_ sender: Any) {
        let vc = SearchViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public enum Section: Int, Hashable {
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

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
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
            return cell
        case Section.showcase.rawValue:
            let cell = dequeueTableViewCell(ofType: ShowcaseTableViewCell.self, with: tableView, for: indexPath)
            cell.onMoreShowcaseTapped = { [weak self] in
                let vc = ListViewController.instantiate()
                vc.type = .movie
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.delegate = self
            return cell
        case Section.actor.rawValue:
            let cell = dequeueTableViewCell(ofType: ActorTableViewCell.self, with: tableView, for: indexPath)
            cell.onMoreActorTapped = { [weak self] in
                let vc = ListViewController.instantiate()
                vc.type = .cast
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.delegate = self
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

extension MainViewController {
    
    func loadData() {
        
        // Fetch slider movies
        movieModel.getSliderMovies(pageNo: nil) { [weak self] result in
            do {
                self?.sliderMovies = try result.get().results
                self?.updateUI(at: .sliderMovies)
            } catch {
                print("[Error: while fetching slider movies]", error)
            }
        }
        
        // Fetch popular movies
        movieModel.getPopularMovies(pageNo: nil){ [weak self] result in
            do {
                self?.popularMovies = try result.get().results
                self?.updateUI(at: .popularMovies)
            } catch {
                print("[Error: while fetching popular movies]", error)
            }
        }
        
        // Fetch popular series
        movieModel.getPopularSeries(pageNo: nil) { [weak self] result in
            do {
                self?.popularSeries = try result.get().results
                self?.updateUI(at: .popularSeries)
            } catch {
                print("[Error: while fetching popular series]", error)
            }
        }
        
    }
    
}

extension MainViewController: MovieItemDelegate, ActorItemDelegate {
    func onFavouriteTapped(isFavourite: Bool) { }
}
