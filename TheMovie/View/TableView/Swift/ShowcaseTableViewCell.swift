//
//  ShowcaseTableViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit

class ShowcaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moreShowcaseLabel: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    var onMoreShowcaseTapped: (() -> Void)?
    var delegate: MovieItemDelegate?
    
    var movies: [Movie]? {
        didSet {
            movieCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moreShowcaseLabel.underline(for: "MORE SHOWCASES")
        moreShowcaseLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMoreShowcaseTapped(_:))))
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func onMoreShowcaseTapped(_ sender: Any) {
        onMoreShowcaseTapped?()
    }
    
}

extension ShowcaseTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: ShowcaseCollectionViewCell.self, for: indexPath, shouldRegister: true)
        cell.movie = movies?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width / 1.3, height: collectionView.frame.height / 1.3)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let horizontalScrollView = scrollView.subviews[(scrollView.subviews.count - 1)].subviews[0]
        horizontalScrollView.backgroundColor = UIColor(named: "Color_Yellow")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onMovieCellTapped(movieId: movies?[indexPath.row].id, type: .movie)
    }
    
}
