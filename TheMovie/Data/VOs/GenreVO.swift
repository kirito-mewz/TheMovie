//
//  GenreVO.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import Foundation

class GenreVO {
    
    var id: Int
    var genreName: String
    var isSelected: Bool = false
    
    init(id: Int = 0, genreName: String, isSelected: Bool) {
        self.id = id
        self.genreName = genreName
        self.isSelected = isSelected
    }
    
}
