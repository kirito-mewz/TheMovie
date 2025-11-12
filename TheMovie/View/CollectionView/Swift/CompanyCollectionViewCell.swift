//
//  CompanyCollectionViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit
import SDWebImage

class CompanyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    var company: ProductionCompany? {
        didSet {
            guard let data = company else { return }
            
            if let image = data.logoPath {
                companyImageView.sd_setImage(with: URL(string: "\(imageBaseURL)/\(image)"))
                companyNameLabel.text = ""
            } else {
                companyNameLabel.text = data.name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
