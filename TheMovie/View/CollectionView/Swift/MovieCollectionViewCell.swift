//
//  MovieCollectionViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var movie: Movie? {
        didSet {
            guard let data = movie else { return }
            
            if let image = data.posterPath {
                movieImageView.sd_setImage(with: URL(string: "\(imageBaseURL)/\(image)"))
            }
            
            movieTitleLabel.text = data.title ?? data.name
            
            ratingLabel.text = String(format: "%.1f", data.voteAverage ?? 0)
            ratingControl.rating = Int(round(data.voteAverage ?? 0) * 0.5)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
