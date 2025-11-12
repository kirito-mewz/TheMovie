//
//  SearchViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

class SearchViewController: UIViewController, Storyboarded {
    
    // MARK: - IBOutlets
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var upButton: UIButton!
    
    // MARK: - Properties
    var queryText = ""
    var currentPage = 1
    var totalPages = 1
    
    var movies: [Movie] = []
    var movieModel: MovieModel = MovieModelImpl.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieSearchBar.delegate = self
        
        upButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let color = UIColor(named: "Color_Yellow")!
        
        if let textFieldInsiderSearchBar = movieSearchBar.value(forKey: "searchField") as? UITextField,
            let iconView = textFieldInsiderSearchBar.leftView as? UIImageView {
                iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
                iconView.tintColor = color
        }
        movieSearchBar.searchTextField.textColor = color
    }

    @IBAction func upButtonTapped(_ sender: Any) {
        movieCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: MovieCollectionViewCell.self, for: indexPath, shouldRegister: true)
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width / 3) + 30, height: (collectionView.frame.height / 3) + 60)
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
        self.onMovieCellTapped()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = indexPath.row == movies.count - 1
        if lastRow && currentPage <= totalPages {
            currentPage += 1
            searchMovies()
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, !text.isEmpty {
            queryText = text
            currentPage = 1
            searchMovies(pageNo: currentPage)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        movies = []
        movieCollectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
}

extension SearchViewController {
    
    func searchMovies(pageNo: Int = 1) {
        movieModel.getSearchMovies(query: queryText, pageNo: pageNo) { [weak self] result in
            do {
                let response = try result.get()
                self?.totalPages = response.totalPages ?? 1
                
                if pageNo == 1 {
                    self?.movies = response.results ?? []
                } else {
                    self?.movies.append(contentsOf: response.results ?? [])
                }
                self?.movieCollectionView.reloadData()
                
            } catch {
                print("[Error while searching movie]", error)
            }
        }
    }
    
}

extension SearchViewController: MovieItemDelegate {
    
}

