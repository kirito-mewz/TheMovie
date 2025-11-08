//
//  SliderCollectionViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(named: "Color_Primary")!.cgColor]
        gradientLayer.locations = [0, 0.7]
        movieImageView.layer.addSublayer(gradientLayer)
        
        let gradientHeight = movieImageView.frame.height * 0.5
        gradientLayer.frame = CGRect(x: 0, y: movieImageView.frame.height - gradientHeight, width: movieImageView.frame.width, height: gradientHeight)
    }

}
