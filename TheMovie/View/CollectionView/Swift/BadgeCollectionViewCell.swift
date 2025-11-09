//
//  BadgeCollectionViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

class BadgeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    
    var data: GenreVO? {
        didSet {
            if let data = data {
                genreLabel.text = data.genreName
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 12
    }

}
