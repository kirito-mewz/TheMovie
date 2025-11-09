//
//  ListViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

class ListViewController: UIViewController, Storyboarded {
    
    enum ListType { case movie, cast }
    
    // MARK: - Properties
    var type: ListType = .movie
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var upButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        upButton.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    @IBAction func onUpButtonTapped(_ sender: Any) {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
}

extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == .movie {
            return 10
        } else {
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if type == .movie {
            let cell = collectionView.dequeueCell(ofType: MovieCollectionViewCell.self, for: indexPath, shouldRegister: true)
            return cell
        } else {
            let cell = collectionView.dequeueCell(ofType: ActorCollectionViewCell.self, for: indexPath, shouldRegister: true)
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
    
}

extension ListViewController: MovieItemDelegate, ActorItemDelegate {
    func onFavouriteTapped(isFavourite: Bool) { }
}
