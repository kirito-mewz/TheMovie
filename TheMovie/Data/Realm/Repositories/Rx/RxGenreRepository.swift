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
    
    private var disposeBag = DisposeBag()
    
    override init() { }
    
    func saveGenres(genres: [Genre]) {
        let obj = genres.map { $0.convertToGenreObject() }
        Observable.from(obj)
            .subscribe(realm.rx.add(update: .modified))
            .disposed(by: disposeBag)
        
    }
    
    func getGenres() -> RxSwift.Observable<[Genre]> {
        let collection: Results<GenreObject> = realm.objects(GenreObject.self)
        return Observable.collection(from: collection)
            .flatMap { objects -> Observable<[Genre]> in
                return Observable.of(objects.map { $0.convertToGenre() } )
            }
    }
    
}
