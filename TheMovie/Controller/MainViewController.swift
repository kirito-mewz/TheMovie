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
    }

    @IBAction func onSearchTapped(_ sender: Any) {
        let vc = SearchViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
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
        case 0:
            let cell = dequeueTableViewCell(ofType: SliderTableViewCell.self, with: tableView, for: indexPath)
            cell.delegate = self
            return cell
        case 1:
            let cell = dequeueTableViewCell(ofType: PopularTableViewCell.self, with: tableView, for: indexPath)
            cell.sectionTitleLabel.text = "BEST POPULAR MOVIES"
            cell.delegate = self
            return cell
        case 2:
            let cell = dequeueTableViewCell(ofType: PopularTableViewCell.self, with: tableView, for: indexPath)
            cell.sectionTitleLabel.text = "BEST POPULAR SERIES"
            cell.delegate = self
            return cell
        case 3:
            let cell = dequeueTableViewCell(ofType: ShowtimeTableViewCell.self, with: tableView, for: indexPath)
            return cell
        case 4:
            let cell = dequeueTableViewCell(ofType: MovieWithGenreTableViewCell.self, with: tableView, for: indexPath)
            cell.delegate = self
            return cell
        case 5:
            let cell = dequeueTableViewCell(ofType: ShowcaseTableViewCell.self, with: tableView, for: indexPath)
            cell.onMoreShowcaseTapped = { [weak self] in
                let vc = ListViewController.instantiate()
                vc.type = .movie
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.delegate = self
            return cell
        case 6:
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

extension MainViewController: MovieItemDelegate, ActorItemDelegate {
    func onFavouriteTapped(isFavourite: Bool) { }
}
