//
//  ActorCollectionViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var heartFilledImageView: UIImageView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeGesture()
    }
    
    fileprivate func initializeGesture() {
        heartImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapFavourite)))
        heartFilledImageView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(onTapUnFavourite)))
    }
    
    @objc fileprivate func onTapFavourite() {
        heartImageView.isHidden = true
        heartFilledImageView.isHidden = false
    }
    
    @objc fileprivate func onTapUnFavourite() {
        heartImageView.isHidden = false
        heartFilledImageView.isHidden = true
    }

}
