//
//  GenreRepository.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 13/11/2025.
//

import RealmSwift

protocol GenreRepository {
    
    func saveGenres(genres: [Genre])
    func getGenres(_ completion: @escaping ([Genre]) -> Void)
    
}
 
final class GenreRepositoryImpl: BaseRepository, GenreRepository {
    
    static let shared: GenreRepository = GenreRepositoryImpl()
    
    override init() { }
    
    func saveGenres(genres: [Genre]) {
        do {
            let obj = genres.map { $0.convertToGenreObject() }
            try realm.write { realm.add(obj, update: .modified) }
        } catch {
            print("\(#function) \(error)")
        }
    }
    
    func getGenres(_ completion: @escaping ([Genre]) -> Void) {
        let objects: Results<GenreObject> = realm.objects(GenreObject.self)
        completion(objects.map { $0.convertToGenre() })
    }
}
