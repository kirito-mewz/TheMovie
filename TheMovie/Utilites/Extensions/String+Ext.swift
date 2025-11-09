//
//  String+Ext.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit

extension String {
    
    func getWidth(of font: UIFont) -> CGFloat {
        let attribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: attribute)
        return size.width
    }
    
}
