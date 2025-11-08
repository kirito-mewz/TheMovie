//
//  RatingControl.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {
    
    @IBInspectable
    var starCount: Int = 3 {
        didSet {
            setupButton()
            setupRating()
        }
    }

    @IBInspectable
    var starSize: CGSize = .init(width: 150, height: 150) {
        didSet {
            setupButton()
            setupRating()
        }
    }
    
    @IBInspectable
    var rating: Int = 3 {
        didSet {
            setupRating()
        }
    }
    
    var ratingButton = [UIButton]()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
        setupRating()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupButton()
        setupRating()
    }
        
    fileprivate func setupButton() {
        
        clearExistingButton()
        
        for _ in 0..<starCount {
            let button = UIButton(frame: .zero)
            button.setImage(#imageLiteral(resourceName: "ic_star_empty"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "ic_star_filled"), for: .selected)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isUserInteractionEnabled = false

            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: starSize.width),
                button.heightAnchor.constraint(equalToConstant: starSize.height)
            ])
            
            addArrangedSubview(button)
            ratingButton.append(button)
        }
    }
    
    fileprivate func setupRating() {
        for (index, button) in ratingButton.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    fileprivate func clearExistingButton() {
        ratingButton.forEach { removeArrangedSubview($0); $0.removeFromSuperview() }
        ratingButton.removeAll()
    }


}
