//
//  ShowcaseCollectionViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit
import SDWebImage

class ShowcaseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var showDateLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            guard let data = movie else { return }
            
            if let image = data.backdropPath {
                movieImageView.sd_setImage(with: URL(string: "\(imageBaseURL)/\(image)"))
            }
            movieTitleLabel.text = data.title
            showDateLabel.text = data.convertToMovieDate()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 6
    }

}
