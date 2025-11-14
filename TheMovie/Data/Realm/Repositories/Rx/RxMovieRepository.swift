//
//  RxMovieRepository.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 14/11/2025.
//

import RxSwift
import RxRealm
import RealmSwift

protocol RxMovieRepository {
    
    func saveMovies(type: MovieDisplayType, page: Int, movies: [Movie])
    func getMovies(type: MovieDisplayType, page: Int) -> Observable<[Movie]>
    
}

final class RxMovieRepositoryImpl: BaseRepository, RxMovieRepository {
    
    static let shared: RxMovieRepository = RxMovieRepositoryImpl()
    
    private var disposeBag = DisposeBag()
    
    override init() { }
    
    func saveMovies(type: MovieDisplayType, page: Int, movies: [Movie]) {
        let obj = movies.map { $0.convertToMovieObj(type: type) }
        Observable.from(obj)
            .subscribe(realm.rx.add(update: .modified))
            .disposed(by: disposeBag)
    }
    
    func getMovies(type: MovieDisplayType, page: Int) -> RxSwift.Observable<[Movie]> {
        let predicate = NSPredicate(format: "displayType = %@ && pageNo = %d", type.rawValue, page)
        let collection: Results<MovieObject> = realm.objects(MovieObject.self).filter(predicate)
        
        return Observable.collection(from: collection)
            .flatMap { objects -> Observable<[Movie]> in
                Observable.of(objects.map { $0.convertToMovie()} )
            }
    }
    
}
