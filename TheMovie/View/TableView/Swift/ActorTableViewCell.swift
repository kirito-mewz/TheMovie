//
//  ActorTableViewCell.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 08/11/2025.
//

import UIKit

class ActorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moreActorLabel: UILabel!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    
    var onMoreActorTapped: (() -> Void)?
    var delegate: ActorItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moreActorLabel.underline(for: "MORE ACTORS")
        moreActorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMoreActorTapped(_:))))
        
        actorCollectionView.delegate = self
        actorCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func onMoreActorTapped(_ sender: Any) {
        onMoreActorTapped?()
    }
    
}

extension ActorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: ActorCollectionViewCell.self, for: indexPath, shouldRegister: true)
        cell.delegate = self.delegate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onActorCellTapped()
    }
    
}
