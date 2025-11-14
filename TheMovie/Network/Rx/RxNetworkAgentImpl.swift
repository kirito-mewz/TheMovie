//
//  RxNetworkAgentImpl.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 14/11/2025.
//

import RxSwift
import RxAlamofire

final class RxNetworkAgentImpl: RxNetworkAgent {
    
    static let shared: RxNetworkAgent = RxNetworkAgentImpl()
    
    // MARK: - Main
    func fetchMovies(withEndpoint endpoint: MDBEndPoint) -> RxSwift.Observable<MovieResponse> {
        RxAlamofire.requestDecodable(endpoint).flatMap { Observable.just($0.1) }
    }
    
    func fetchGenres(withEndpoint endpoint: MDBEndPoint) -> RxSwift.Observable<[Genre]> {
        RxAlamofire.requestDecodable(endpoint)
            .compactMap { tuple -> MovieGenres in tuple.1 }
            .flatMap { Observable.just($0.genres ?? []) }
    }
    
    func fetchShowcaseMovies(withEndpoint endpoint: MDBEndPoint) -> RxSwift.Observable<MovieResponse> {
        RxAlamofire.requestDecodable(endpoint).flatMap { Observable.just($0.1) }
    }
    
    func fetchActors(withEndpoint endpoint: MDBEndPoint) -> RxSwift.Observable<ActorResponse> {
        RxAlamofire.requestDecodable(endpoint).flatMap { Observable.just($0.1) }
    }
    
    func fetchSearchMovies(with query: String, page: Int) -> RxSwift.Observable<MovieResponse> {
        let whiteSpaceReplaceStr: String = query.replacingOccurrences(of: " " , with: "+")
        return RxAlamofire.requestDecodable(MDBEndPoint.searchMovies(query: whiteSpaceReplaceStr))
            .flatMap { Observable.just($0.1) }
    }
    
    // MARK: - Movie Detail
    func fetchMovieDetail(movieId id: Int, type: MovieType) -> RxSwift.Observable<MovieDetailResponse> {
        RxAlamofire.requestDecodable(MDBEndPoint.movieDetail(id: id, type: type)).flatMap { Observable.just($0.1) }
    }
    
    func fetchMovieTrailer(movieId id: Int, type: MovieType) -> Observable<Trailer> {
        RxAlamofire.requestDecodable(MDBEndPoint.movieTrailer(id: id, type: type))
            .map { (_, response: MovieTrailerResponse) in
                guard let trailer = response.results?.first else {
                    fatalError("RxAlamofire Movie Trailer Error")
                }
                return trailer
            }
    }
    
    func fetchMovieActors(movidId id: Int, type: MovieType) -> RxSwift.Observable<[Actor]> {
        RxAlamofire.requestDecodable(MDBEndPoint.movieActors(id: id, type: type))
            .map { tuple -> MovieCreditResponse in
                return tuple.1
            }
            .flatMap { credit in
                return Observable.of(credit.convertToActor() ?? [])
            }
    }
    
    func fetchSimilarMovies(movieId id: Int, type: MovieType) -> RxSwift.Observable<MovieResponse> {
        RxAlamofire.requestDecodable(MDBEndPoint.similarMovies(id: id, type: type)).flatMap { Observable.just($0.1) }
    }
    
    // MARK: - Actor Detail
    func fetchActorDetail(actorId id: Int) -> RxSwift.Observable<ActorDetailResponse> {
        RxAlamofire.requestDecodable(MDBEndPoint.actorDetail(id: id)).flatMap { Observable.just($0.1) }
    }
    
    func fetchActorMovies(actorId id: Int) -> RxSwift.Observable<ActorCreditResponse> {
        RxAlamofire.requestDecodable(MDBEndPoint.actorMovies(id: id)).flatMap { Observable.just($0.1) }
    }
    
    
}
