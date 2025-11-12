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
    
    var genre: Genre? {
        didSet {
            if let data = genre {
                genreLabel.text = data.name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 12
    }

}
