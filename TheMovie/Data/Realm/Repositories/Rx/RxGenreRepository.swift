//
//  RxGenreRepository.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 14/11/2025.
//

import RxSwift
import RxRealm
import RealmSwift

protocol RxGenreRepository {
    
    func saveGenres(genres: [Genre])
    func getGenres() -> Observable<[Genre]>
    
}

final class RxGenreRepositoryImpl: BaseRepository, RxGenreRepository {
    
    static let shared: RxGenreRepository = RxGenreRepositoryImpl()
    
    override init() { }
    
    func saveGenres(genres: [Genre]) {
        do {
            let obj = genres.map { $0.convertToGenreObject() }
            try realm.write { realm.add(obj, update: .modified) }
        } catch {
            print("\(#function) \(error)")
        }
    }
    
    func getGenres() -> RxSwift.Observable<[Genre]> {
        let collection: Results<GenreObject> = realm.objects(GenreObject.self)
        return Observable.collection(from: collection)
            .flatMap { objects -> Observable<[Genre]> in
                return Observable.of(objects.map { $0.convertToGenre() } )
            }
    }
    
}
