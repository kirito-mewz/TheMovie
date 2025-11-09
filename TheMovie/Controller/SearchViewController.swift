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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: MovieCollectionViewCell.self, for: indexPath, shouldRegister: true)
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
    
}

extension SearchViewController: MovieItemDelegate {
    
}

