//
//  RxMovieModel.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 14/11/2025.
//

import RxSwift

protocol RxMovieModel {
    
    func getSliderMovies(pageNo: Int?) -> Observable<MovieResponse>
    func getPopularMovies(pageNo: Int?) -> Observable<MovieResponse>
    func getPopularSeries(pageNo: Int?) -> Observable<MovieResponse>
    func getShowcaseMovies(pageNo: Int?) -> Observable<MovieResponse>
//    func getSearchMovies(query: String, pageNo: Int?) -> Observable<MovieResponse>
    
    func getMovieDetail(movieId id: Int, type: MovieType) -> Observable<MovieDetailResponse?>
    func getMovieTrailer(movieId id: Int, type: MovieType) -> Observable<Trailer>
    func getMovieActors(movieId id: Int, type: MovieType) -> Observable<[Actor]>
    func getSimilarMovies(movieId id: Int, type: MovieType) -> Observable<MovieResponse>
    
}

final class RxMovieModelImpl: BaseModel, RxMovieModel {
    
    static let shared: RxMovieModel = RxMovieModelImpl()
    private let rxRepo: RxMovieRepository = RxMovieRepositoryImpl.shared
    
    private override init() { }
    
    func getSliderMovies(pageNo: Int?) -> RxSwift.Observable<MovieResponse> {
        rxNetworkAgent.fetchMovies(withEndpoint: .sliderMovies(pageNo: pageNo ?? 1))
            .do { [weak self] response in
                self?.rxRepo.saveMovies(type: .sliderMovies, page: pageNo ?? 1, movies: response.results ?? [])
            } onError: { error in
                print("\(#function) \(error)")
            }
            .flatMap { response -> Observable<MovieResponse> in
                return self.rxRepo.getMovies(type: .sliderMovies, page: pageNo ?? 1)
                    .flatMap { movies in
                        return Observable.of(MovieResponse(dates: response.dates, page: response.page, results: movies, totalPages: response.totalPages, totalResults: response.totalResults))
                    }
            }
    }
    
    func getPopularMovies(pageNo: Int?) -> RxSwift.Observable<MovieResponse> {
        rxNetworkAgent.fetchMovies(withEndpoint: .popular(pageNo: pageNo ?? 1, type: .movie))
            .do { [weak self] response in
                self?.rxRepo.saveMovies(type: .popularMovies, page: pageNo ?? 1, movies: response.results ?? [])
            } onError: { error in
                print("\(#function) \(error)")
            }
            .flatMap { response -> Observable<MovieResponse> in
                return self.rxRepo.getMovies(type: .popularMovies, page: pageNo ?? 1)
                    .flatMap { movies in
                        return Observable.of(MovieResponse(dates: response.dates, page: response.page, results: movies, totalPages: response.totalPages, totalResults: response.totalResults))
                    }
            }
    }
    
    func getPopularSeries(pageNo: Int?) -> RxSwift.Observable<MovieResponse> {
        rxNetworkAgent.fetchMovies(withEndpoint: .popular(pageNo: pageNo ?? 1, type: .series))
            .do { [weak self] response in
                self?.rxRepo.saveMovies(type: .popularSeries, page: pageNo ?? 1, movies: response.results ?? [])
            } onError: { error in
                print("\(#function) \(error)")
            }
            .flatMap { response -> Observable<MovieResponse> in
                return self.rxRepo.getMovies(type: .popularSeries, page: pageNo ?? 1)
                    .flatMap { movies in
                        return Observable.of(MovieResponse(dates: response.dates, page: response.page, results: movies, totalPages: response.totalPages, totalResults: response.totalResults))
                    }
            }
    }
    
    func getShowcaseMovies(pageNo: Int?) -> RxSwift.Observable<MovieResponse> {
        rxNetworkAgent.fetchMovies(withEndpoint: .showcaseMovies(pageNo: pageNo ?? 1))
            .do { [weak self] response in
                self?.rxRepo.saveMovies(type: .showcaseMovies, page: pageNo ?? 1, movies: response.results ?? [])
            } onError: { error in
                print("\(#function) \(error)")
            }
            .flatMap { response -> Observable<MovieResponse> in
                self.rxRepo.getMovies(type: .showcaseMovies, page: pageNo ?? 1)
                    .flatMap { movies in
                        return Observable.of(MovieResponse(dates: response.dates, page: response.page, results: movies, totalPages: response.totalPages, totalResults: response.totalResults))
                    }
            }
    }
    
//    func getSearchMovies(query: String, pageNo: Int?) -> RxSwift.Observable<MovieResponse> {
//        
//    }
    
    func getMovieDetail(movieId id: Int, type: MovieType) -> RxSwift.Observable<MovieDetailResponse?> {
        rxNetworkAgent.fetchMovieDetail(movieId: id, type: type)
            .do { [weak self] response in
                self?.rxRepo.saveMovieDetail(movieId: id, detail: response)
            } onError: { error in
                print("\(#function) \(error)")
            }
            .flatMap { response -> Observable<MovieDetailResponse?> in
                self.rxRepo.getMovieDetail(movieId: response.id ?? -1)
            }
    }
    
    func getMovieTrailer(movieId id: Int, type: MovieType) -> RxSwift.Observable<Trailer> {
        rxNetworkAgent.fetchMovieTrailer(movieId: id, type: type)
    }
    
    func getMovieActors(movieId id: Int, type: MovieType) -> RxSwift.Observable<[Actor]> {
        rxNetworkAgent.fetchMovieActors(movidId: id, type: type)
    }
    
    func getSimilarMovies(movieId id: Int, type: MovieType) -> RxSwift.Observable<MovieResponse> {
        rxNetworkAgent.fetchSimilarMovies(movieId: id, type: type)
            .do { [weak self] response in
                self?.rxRepo.saveMovies(type: .similarMoves, page: 1, movies: response.results ?? [])
            } onError: { error in
                print("\(#function) \(error)")
            }
    }
    

}
