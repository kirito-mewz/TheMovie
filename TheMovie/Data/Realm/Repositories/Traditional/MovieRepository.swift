//
//  MovieRepository.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 13/11/2025.
//

import RealmSwift

protocol MovieRepository {
    
    func saveMovies(type: MovieDisplayType, page: Int, movies: [Movie])
    func getMovies(type: MovieDisplayType, page: Int, _ completion: @escaping ([Movie]) -> Void)
    
    func saveMovieDetail(movieId id: Int, detail: MovieDetailResponse)
    func getMovieDetail(movieId id: Int, _ completion: @escaping(MovieDetailResponse?) -> Void)
    
}

final class MovieRepositoryImpl: BaseRepository, MovieRepository {
    
    static let shared: MovieRepository = MovieRepositoryImpl()
    
    override init() { }
    
    func saveMovies(type: MovieDisplayType, page: Int, movies: [Movie]) {
        do {
            let obj = movies.map { $0.convertToMovieObj(type: type, pageNo: page) }
            try realm.write { realm.add(obj, update: .modified) }
        } catch {
            print("\(#function) \(error)")
        }
    }
    
    func getMovies(type: MovieDisplayType, page: Int, _ completion: @escaping ([Movie]) -> Void) {
        let predicate = NSPredicate(format: "displayType = %@ && pageNo = %d", type.rawValue, page)
        let objects: Results<MovieObject> = realm.objects(MovieObject.self).filter(predicate)
        completion(objects.map { $0.convertToMovie() } )
    }
    
    func saveMovieDetail(movieId id: Int, detail: MovieDetailResponse) {
        findMovieById(id) { [weak self] movie in
            guard let self = self, let movie = movie else { return }
            do {
                try self.realm.write {
                    movie.detail = detail.convertToMovieDetailEmbeddedObject()
                    self.realm.add(movie.detail!.genres, update: .modified)
                    self.realm.add(movie, update: .modified)
                }
            } catch {
                print("\(#function) \(error)")
            }
        }
    }
    
    func getMovieDetail(movieId id: Int, _ completion: @escaping(MovieDetailResponse?) -> Void) {
        findMovieById(id) { movie in
            completion(movie?.detail?.convertToMovieDetail())
        }
    }
    
    func findMovieById(_ id: Int, completion: @escaping (MovieObject?) -> Void) {
        completion(realm.object(ofType: MovieObject.self, forPrimaryKey: id))
    }
    
}
