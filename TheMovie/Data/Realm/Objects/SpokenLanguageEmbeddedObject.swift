//
//  SpokenLanguageObject.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 13/11/2025.
//

import RealmSwift

class SpokenLanguageEmbeddedObject: EmbeddedObject {
    @Persisted var name: String?
    @Persisted var  englishName: String?
    @Persisted var iso639_1: String?
    
    func convertToSpokenLanguage() -> SpokenLanguage {
        SpokenLanguage(englishName: englishName, iso639_1: iso639_1, name: name)
    }
}
