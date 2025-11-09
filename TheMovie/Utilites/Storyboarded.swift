//
//  Storyboarded.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
}
