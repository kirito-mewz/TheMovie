//
//  ActorCollectionViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit
import SDWebImage

class ActorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var heartFilledImageView: UIImageView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    var delegate: ActorItemDelegate?
    
    var actor: Actor? {
        didSet {
            guard let data = actor else { return }
            
            if let image = data.profilePath {
                actorImageView.sd_setImage(with: URL(string: "\(imageBaseURL)/\(image)"))
            }
            
            actorNameLabel.text = data.name
            roleLabel.text = data.role
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeGesture()
    }
    
    fileprivate func initializeGesture() {
        heartImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapFavourite)))
        heartFilledImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapUnfavourite)))
    }
    
    @objc fileprivate func onTapFavourite() {
        heartImageView.isHidden = true
        heartFilledImageView.isHidden = false
        delegate?.onFavouriteTapped(isFavourite: true)
    }
    
    @objc fileprivate func onTapUnfavourite() {
        heartImageView.isHidden = false
        heartFilledImageView.isHidden = true
        delegate?.onFavouriteTapped(isFavourite: false)
    }

}
