//
//  GenreObject.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 13/11/2025.
//

import RealmSwift

class GenreObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    
    func convertToGenre() -> Genre {
        Genre(id: id, name: name)
    }
}
