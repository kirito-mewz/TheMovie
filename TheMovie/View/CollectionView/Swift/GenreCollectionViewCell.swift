//
//  GenreCollectionViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    
    var onGenreTap: ((Int) -> Void) = {_ in}
    
    var genre: GenreVO? {
        didSet {
            if let data = genre {
                genreLabel.text = data.genreName
                overlayView.isHidden = !data.isSelected
                genreLabel.textColor = data.isSelected ? .white : .init(red: 63/255, green: 69/255, blue: 96/255, alpha: 1)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(_didCellTap)))
    }
    
    @objc private func _didCellTap() {
        onGenreTap(genre?.id ?? 0)
    }
    

}
